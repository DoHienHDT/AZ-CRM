//
//  ListTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ListTaskController: BaseViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    private let refreshControl = UIRefreshControl()
    
    var listTask = [ListTaskModel]()
    var searchTableView = [ListTaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reuqestData()
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
        
        tableView.isHidden = true
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        
        tableView.register(UINib(nibName: "ListTaskCell", bundle: nil), forCellReuseIdentifier: "ListTaskCell")
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func filterButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "filterTaskController", sender: self)
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        performSegue(withIdentifier: "addTaskController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FilterTaskController {
            vc.delegate = self
        }
        if let vc = segue.destination as? AddTaskController {
            vc.delegate = self
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.reuqestData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableView = listTask
            tableView.reloadData()
            return
        }
        
        searchTableView = listTask.filter({ (infoList) -> Bool in
            infoList.tencv.lowercased().contains(searchText.lowercased()) ||
                infoList.macv.lowercased().contains(searchText.lowercased())
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
        searchTableView = listTask
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

extension ListTaskController {
    
    func reuqestData() {

        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                 if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let date = Date()
                let dateformat = DateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy"
                let dateString = dateformat.string(from: date)
                let previousMonth = Calendar.current.date(byAdding: .month, value: -3, to: date)!
                let previousMonthString = dateformat.string(from: previousMonth)
                
                let param: Parameters = ["method":"tasks","rtype":entity.last!.rtype!, "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!,"manv":entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay":previousMonthString,"denngay":dateString,"seckey":urlRegister.last!.seckey!]
                print("Api List Task     ------    \(param)")
                TaskRequest.getTask(parameter: param) { [unowned self] (listTask) in
                    self.listTask = listTask
                    self.searchTableView = self.listTask
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension ListTaskController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTaskCell", for: indexPath) as! ListTaskCell
        cell.mattLabel.text = searchTableView[indexPath.row].trangthai
        cell.ngaybdLabel.text = searchTableView[indexPath.row].ngaybd
        cell.ngayktLabel.text = searchTableView[indexPath.row].ngaykt
        cell.tencvLabel.text = searchTableView[indexPath.row].tencv
        cell.tenkhLabel.text = searchTableView[indexPath.row].tenkh
        cell.matdLabel.text = searchTableView[indexPath.row].tiendo.description
        cell.nguoinhapLabel.text = searchTableView[indexPath.row].nguoinhap
        
        if searchTableView[indexPath.row].hoanthanh == true {
            cell.mattButton.imageView?.image = UIImage(named: "checkBox1")
        } else {
            cell.mattButton.imageView?.image = UIImage(named: "checkbox2")
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "InfoTaskController", bundle: nil)
        
        let headerViewController = storyboard.instantiateViewController(withIdentifier: "InfoTaskContentController")
        if let firstViewController = storyboard.instantiateViewController(withIdentifier: "InfoTaskController") as? InfoTaskController {
            firstViewController.macv = Int(searchTableView[indexPath.row].macv)
            firstViewController.title  = "Thông tin"
            
            if let secondViewController = storyboard.instantiateViewController(withIdentifier: "InfoStaffTaskController") as? InfoStaffTaskController {
                secondViewController.macv = Int(searchTableView[indexPath.row].macv)
                secondViewController.title = "Nhân viên"
                
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
}

extension ListTaskController: AddTaskControllerDelegate {
    func reloadDataAdd() {
        reuqestData()
    }
}

extension ListTaskController: FllowWorkControllerDelegate {
    func reloadData() {
        reuqestData()
    }
}

extension ListTaskController: EditTaskControllerDelegate {
    func reloadEdit() {
        reuqestData()
    }
}

extension ListTaskController: FilterTaskControllerDelegate {
    
    func senDataFilter(tungay: String, denngay: String, matt: String, mact: String) {
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                 if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                if mact != "" && matt == "" {
                    let param: Parameters = ["method":"tasks","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": mact, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":"","seckey":urlRegister.last!.seckey!]
                    print(param)
                    TaskRequest.getTask(parameter: param) { [unowned self] (task) in
                        
                        self.listTask = task
                        self.searchTableView = self.listTask
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
                
                if mact == "" && matt != "" {
                    let param: Parameters = ["method":"tasks","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":matt,"seckey":urlRegister.last!.seckey!]
                    print(param)
                    TaskRequest.getTask(parameter: param) { [unowned self] (task) in
                        
                        self.listTask = task
                        self.searchTableView = self.listTask
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
                
                if mact == "" && matt == "" {
                    let param: Parameters = ["method":"tasks","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":"","seckey":urlRegister.last!.seckey!]
                    print(param)
                    TaskRequest.getTask(parameter: param) { [unowned self] (task) in
                        
                        self.listTask = task
                        self.searchTableView = self.listTask
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        
                    }
                }
                
                if mact != "" && matt != "" {
                    let param: Parameters = ["method":"tasks","rtype": entity.last!.rtype! , "isadmin": entity.last!.isadmin!, "mact": mact, "manv": entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay": tungay ,"denngay":denngay ,"matt":matt,"seckey":urlRegister.last!.seckey!]
                    print(param)
                    TaskRequest.getTask(parameter: param) { [unowned self] (task) in
                        
                        self.listTask = task
                        self.searchTableView = self.listTask
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

extension ListTaskController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let storyboard = UIStoryboard(name: "EditTaskController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "EditTaskController") as? EditTaskController {
                    vc.delegate = self
                    vc.macv = Int(self.searchTableView[indexPath.row].macv)
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
                            let param: Parameters = ["method": "taskdelete","macv": self.searchTableView[indexPath.row].macv , "seckey":urlRegister.last!.seckey!]
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
            
            let xuly = SwipeAction(style: .destructive, title: nil) { (action, indexPath) in
                let storyboard = UIStoryboard(name: "ProcessTaskController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "FllowWorkController") as? FllowWorkController {
                    vc.macv = Int(self.searchTableView[indexPath.row].macv)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            configure(action: xuly, with: .xuly)
            
            return[delete, edit, xuly]
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
                                    
                                    self.listTask.remove(at: indexPath)
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
