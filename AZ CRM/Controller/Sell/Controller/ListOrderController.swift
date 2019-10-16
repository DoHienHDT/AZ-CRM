//
//  ListOrderController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ListOrderController: BaseViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOrder = [ListOrderModel]()
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var status = " "
    
    var searchTableView = [ListOrderModel]()
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
        
        request(matt: "")
        tableView.isHidden = true
        tableView.register(UINib(nibName: "OderTableViewCell", bundle: nil), forCellReuseIdentifier: "OderTableViewCell")
        
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        tableView.reloadData()
        status = " "
        request(matt: "")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func alertStatusButton(_ sender: Any) {
        performSegue(withIdentifier: "filterOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FilterOrderController {
            vc.delegate = self
        }
    }
    
    @IBAction func addOrderButton(_ sender: UIButton) {
        let storyboad = UIStoryboard(name: "AddOrderController", bundle: nil)
        if let vc = storyboad.instantiateViewController(withIdentifier: "AddOrderController") as? AddOrderController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension ListOrderController: FilterOrderControllerDelegate {
    func senFilterData(matt: String, mact: String, tungay: String, denngay: String, status: String) {
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    if mact != "" && matt == "" {
                        let param: Parameters = ["method":"orders","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": mact, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":"","seckey":urlRegister.last!.seckey!]
                        print(param)
                        self.status = status
                        RequestListOerder.getOrder(parameter: param) { [unowned self] (order) in
                            
                            self.listOrder = order
                            self.searchTableView = self.listOrder
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }
                    
                    if mact == "" && matt != "" {
                        let param: Parameters = ["method":"orders","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":matt,"seckey":urlRegister.last!.seckey!]
                        print(param)
                        self.status = status
                        RequestListOerder.getOrder(parameter: param) { [unowned self] (order) in
                            
                            self.listOrder = order
                            self.searchTableView = self.listOrder
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }
                    
                    if mact == "" && matt == "" {
                        let param: Parameters = ["method":"orders","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":"","seckey":urlRegister.last!.seckey!]
                        print(param)
                        self.status = status
                        RequestListOerder.getOrder(parameter: param) { [unowned self] (order) in
                            
                            self.listOrder = order
                            self.searchTableView = self.listOrder
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }
                    
                    if mact != "" && matt != "" {
                        let param: Parameters = ["method":"orders","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": mact, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":matt,"seckey":urlRegister.last!.seckey!]
                        print(param)
                        self.status = status
                        RequestListOerder.getOrder(parameter: param) { [unowned self] (order) in
                            
                            self.listOrder = order
                            self.searchTableView = self.listOrder
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension ListOrderController: EditOrderControllerDelegate {
    func reloadEdit() {
        request(matt: "")
    }
}

extension ListOrderController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableView = listOrder
            tableView.reloadData()
            return
        }
        searchTableView = listOrder.filter({ (infoList) -> Bool in
            infoList.doituong.lowercased().contains(searchText.lowercased())
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
        searchTableView = listOrder
        tableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
}

extension ListOrderController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OderTableViewCell", for: indexPath) as! OderTableViewCell
        cell.sophieuLb.text = searchTableView[indexPath.row].sodh
        cell.diadiemLb.text = searchTableView[indexPath.row].diadiemgiaohang
        cell.doituongLb.text = searchTableView[indexPath.row].doituong
        cell.nhanvienLb.text = searchTableView[indexPath.row].nhanvien
        cell.ngayDhLb.text = searchTableView[indexPath.row].ngaydh
        cell.trangthaiLb.text = status
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "InfoOrderController", bundle: nil)
        let headerViewController = storyboard.instantiateViewController(withIdentifier: "InfoOrderContentController")
        
        if let firstViewController = storyboard.instantiateViewController(withIdentifier: "InfoOrderController") as? InfoOrderController {
            firstViewController.madh = Int(searchTableView[indexPath.row].madh)
            firstViewController.title  = "Đơn hàng"
            if let secondViewController = storyboard.instantiateViewController(withIdentifier: "InfoProductOrderController") as? InfoProductOrderController {
                secondViewController.madh =  Int(searchTableView[indexPath.row].madh)
                secondViewController.title = "Sản phẩm"
                
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
}

extension ListOrderController {
    
    func request(matt: String) {
        let date = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        let dateString = dateformat.string(from: date)
        let previousMonth = Calendar.current.date(byAdding: .month, value: -3, to: date)!
        let previousMonthString = dateformat.string(from: previousMonth)
        
        // Lấy dữ liệu từ coredata
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    
                    let param: Parameters = ["method":"orders","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": "\(previousMonthString)","denngay":"\(dateString)","matt":"\(matt)","seckey":urlRegister.last!.seckey!]
                    print(param)
                    RequestListOerder.getOrder(parameter: param) { [unowned self] (order) in
                        
                        self.listOrder = order
                        self.searchTableView = self.listOrder
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
                                    
                                    self.listOrder.remove(at: indexPath)
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.request(matt: "")
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

extension ListOrderController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let soryboad = UIStoryboard(name: "EditOrderController", bundle: nil)
                if let vc = soryboad.instantiateViewController(withIdentifier: "EditOrderController") as? EditOrderController {
                    vc.madh = Int(self.searchTableView[indexPath.row].madh)
                    vc.delegate = self
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
                            let param: Parameters = ["method": "orderdelete","madh": Int(self.searchTableView[indexPath.row].madh) , "seckey": urlRegister.last!.seckey!]
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
        } else {
            return nil
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

