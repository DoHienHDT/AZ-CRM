//
//  ListCustomerViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import os.log
class ListCustomerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    var customerList = [Customer]()
    var searchTableView = [Customer]()
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listCustomerView: UIView!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var filteredArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCustomerView.dropShadow()
        
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
        
        tableView.isHidden = true
        SVProgressHUD.show()
        
        tableView.register(UINib(nibName: "CustomerInforTableViewCell", bundle: nil), forCellReuseIdentifier: "customerInforCell")
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
    }
    
    func reuqestData() {
        //Lấy dữ liệu từ coreData
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    let param: Parameters = ["method": "customers","rtype":entity.last!.rtype!,"isadmin":entity.last!.isadmin!, "mact": entity.last!.mact!, "manv":entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd":entity.last!.mankd!,"seckey": urlRegister.last!.seckey!]
                    print(param)
                    RequestCustomer.getCustomer(parameter: param) { [unowned self] (customer) in
                        
                        self.customerList = customer
                        self.searchTableView = self.customerList
                        self.tableView.isHidden = false
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
                    }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        reuqestData()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableView = customerList
            tableView.reloadData()
            return
        }
        
        searchTableView = customerList.filter({ (infoList) -> Bool in
            infoList.company.lowercased().contains(searchText.lowercased()) ||
                infoList.mail.lowercased().contains(searchText.lowercased()) ||
                infoList.abbreviationName.lowercased().contains(searchText.lowercased()) ||
                infoList.phone.lowercased().contains(searchText.lowercased())
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
        searchTableView = customerList
        tableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.reuqestData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCustomer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddCustomerController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddCustomerController") as? AddCustomerController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerInforCell", for: indexPath) as! CustomerInforTableViewCell
        cell.delegate = self
        cell.phoneLabel.text = searchTableView[indexPath.row].phone
        cell.mailLabel.text = searchTableView[indexPath.row].mail
        cell.companyLabel.text = searchTableView[indexPath.row].company
        cell.abbreviationNameLabel.text = searchTableView[indexPath.row].abbreviationName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchTableView[indexPath.row].makh)
        let storyboard = UIStoryboard(name: "InfoCustomerController", bundle: nil)
        let headerViewController = storyboard.instantiateViewController(withIdentifier: "customerDetail")
        
        if let firstViewController = storyboard.instantiateViewController(withIdentifier: "infoCustomer") as? InfoCustomerController {
            firstViewController.makh = Int(searchTableView[indexPath.row].makh)
            firstViewController.title  = "Khách hàng"
            
            if let secondViewController = storyboard.instantiateViewController(withIdentifier: "contactCustomer") as? InfoContactCustomerController {
                secondViewController.makh =  Int(searchTableView[indexPath.row].makh)
                secondViewController.title = "Liên hệ"
                
                let segmentController = SJSegmentedViewController()
                segmentController.headerViewController = headerViewController
                segmentController.segmentControllers = [firstViewController, secondViewController]
                segmentController.headerViewHeight = 70
                segmentController.headerViewOffsetHeight = 31.0
                segmentController.segmentTitleColor = .lightGray
                segmentController.segmentSelectedTitleColor = .black
                
                navigationController?.pushViewController(segmentController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
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
                                    
                                    self.customerList.remove(at: indexPath)
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.reuqestData()
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

extension ListCustomerViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let mailCustomer = customerList[indexPath.row]
        if orientation == .left {
            let mail = SwipeAction(style: .default, title: nil) { (action, indexpath) in
                if let url = URL(string: "mailto:\(mailCustomer.mail)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            configure(action: mail, with: .unread)
            
            let call = SwipeAction(style: .default, title: nil) { (_, _) in
                guard let number = URL(string: "tel://" + mailCustomer.phone) else { return }
                UIApplication.shared.open(number)
            }
            configure(action: call, with: .call)
            return [mail, call]
        } else {
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let storyboard = UIStoryboard(name: "EditCustomerController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "EditCustomerController") as? EditCustomerController {
                    vc.makh = self.searchTableView[indexPath.row].makh
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
                            let param: Parameters = ["method": "customerdelete","makh": Int(self.customerList[indexPath.row].makh) , "seckey": urlRegister.last!.seckey!]
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
            
            return[delete, edit]
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .selection
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
}

