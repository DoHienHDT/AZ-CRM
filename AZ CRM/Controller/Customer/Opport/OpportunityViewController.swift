//
//  OpportunityViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class OpportunityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var oport = [OpportModel]()
    var searchTableView = [OpportModel]()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
                topButtonRight.constant = CGFloat(entity.last!.heightTopButtonRight)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.tableView.isHidden = true
        SVProgressHUD.show()
        tableView.register(UINib(nibName: "OpportTableViewCell", bundle: nil), forCellReuseIdentifier: "oport")
        
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestOport()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.requestOport()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableView = oport
            tableView.reloadData()
            return
        }
        
        searchTableView = oport.filter({ (infoList) -> Bool in
            infoList.nameOpport.lowercased().contains(searchText.lowercased()) ||
                infoList.emailOpport.lowercased().contains(searchText.lowercased()) ||
                infoList.telOpport.lowercased().contains(searchText.lowercased()) ||
                infoList.masoOpport.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchTableView = oport
        tableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addOpportButton(_ sender: Any) {
        let storyboad = UIStoryboard(name: "AddOpportController", bundle: nil)
        if let vc = storyboad.instantiateViewController(withIdentifier: "AddOportController") as? AddOportController {
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "oport", for: indexPath) as! OpportTableViewCell
        cell.nameLabel.text = searchTableView[indexPath.row].nameOpport
        cell.mailLabel.text = searchTableView[indexPath.row].emailOpport
        cell.masoLabel.text = searchTableView[indexPath.row].masoOpport
        cell.potentialLabel.text = String(searchTableView[indexPath.row].potentialOpport)
        cell.telLabel.text = searchTableView[indexPath.row].telOpport
        cell.valueLabel.text = String(searchTableView[indexPath.row].valueOpport)
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "InfoOpportCustomerController", bundle: nil)
        
        let headerViewController = storyboard.instantiateViewController(withIdentifier: "TakeCareOportController")
        if let firstViewController = storyboard.instantiateViewController(withIdentifier: "TakeCareOpportDetailController") as? TakeCareOpportDetailController {
            
            firstViewController.mancOpport = searchTableView[indexPath.row].mancOpport
            firstViewController.title  = "Thông tin"
            if let secondViewController = storyboard.instantiateViewController(withIdentifier: "TakeCareOpportProductDetailController") as? TakeCareOpportProductDetailController {
                secondViewController.mancOpport = searchTableView[indexPath.row].mancOpport
                secondViewController.title = "Sản phẩm"
                let segmentController = SJSegmentedViewController()
                segmentController.headerViewController = headerViewController
                segmentController.segmentControllers = [firstViewController, secondViewController]
                segmentController.headerViewHeight = 70
                segmentController.headerViewOffsetHeight = 31.0
                segmentController.segmentTitleColor = .lightGray
                segmentController.segmentSelectedTitleColor = .black
                
                self.navigationController?.pushViewController(segmentController, animated: true)
            }
        }
    }
    
    func requestOport() {
        
        let date = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        let dateString = dateformat.string(from: date)
        let previousMonth = Calendar.current.date(byAdding: .month, value: -3, to: date)!
        let previousMonthString = dateformat.string(from: previousMonth)
        
        //Lấy dữ liệu từ coreData
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    let param: Parameters = ["method": "opportunities", "rtype": entity.last!.rtype!, "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!, "manv": entity.last!.manv!, "mapb" : entity.last!.mapb!, "mankd" : entity.last!.mankd!, "tungay": "\(previousMonthString)","denngay":"\(dateString)","seckey": urlRegister.last!.seckey!]
                    print(param)
                    
                    RequestOport.getOport(parameter: param) { [unowned self] (oport) in
                        self.oport = oport
                        self.searchTableView = self.oport
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}

extension OpportunityViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let xuly = SwipeAction(style: .default, title: nil) { (_, _) in
                
                let storyboard = UIStoryboard(name: "OpportProcessCustomerController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "OpportProcessController") as? OpportProcessController {
                    vc.manc = self.searchTableView[indexPath.row].mancOpport
                    vc.maso = self.searchTableView[indexPath.row].masoOpport
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            configure(action: xuly, with: .xuly)
            xuly.hidesWhenSelected = true
            
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let storyboard = UIStoryboard(name: "EditOpportController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "EditOpportController") as? EditOpportController {
                    vc.mancOpport = self.searchTableView[indexPath.row].mancOpport
                    vc.makh = self.searchTableView[indexPath.row].makh
                    vc.makhString = self.searchTableView[indexPath.row].nameOpport
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            edit.hidesWhenSelected = true
            configure(action: edit, with: .edit)
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let openActionCancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
                let openActionDelete = UIAlertAction(title: "Xoá", style: .destructive, handler: { (_) in
                    
                    do {
                        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let param: Parameters = ["method": "opportunitydelete","manc": Int(self.searchTableView[indexPath.row].mancOpport) , "seckey": urlRegister.last!.seckey!]
                            self.deleteRows(paramer: param, indexPath: indexPath.row)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                alert.addAction(openActionDelete)
                alert.addAction(openActionCancel)
                self.present(alert, animated: true, completion: nil)
            }
            
            configure(action: delete, with: .trash)
            
            return[delete, edit, xuly]
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .right ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        }
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
    
    func deleteRows(paramer: Parameters!, indexPath: Int) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramer, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        if let valueString = response.result.value as? [String: Any] {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                    
                                    SVProgressHUD.show()
                                    
                                    self.oport.remove(at: indexPath)
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.requestOport()
                                    })
                                    
                                } else {
                                    let alert = UIAlertController(title: "Messages", message: "\(value)", preferredStyle: .alert)
                                    let openAction = UIAlertAction(title: "OK", style: .cancel)
                                    alert.addAction(openAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    case .failure(_):
                        print("failse")
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}

