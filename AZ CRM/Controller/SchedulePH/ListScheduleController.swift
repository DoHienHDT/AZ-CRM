//
//  ListScheduleController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ListScheduleController: BaseViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var schedule = [ListScheduleModel]()
    var searchTableView = [ListScheduleModel]()
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
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
        
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        
        tableView.register(UINib(nibName: "ListScheduleCell", bundle: nil), forCellReuseIdentifier: "ListScheduleCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestData()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableView = schedule
            tableView.reloadData()
            return
        }
        
        searchTableView = schedule.filter({ (infoList) -> Bool in
            infoList.tieude.lowercased().contains(searchText.lowercased())
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
        searchTableView = schedule
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
        requestData()
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addSchedules(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddScheduleController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddSchedulesController") as? AddSchedulesController {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ListScheduleController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListScheduleCell", for: indexPath) as! ListScheduleCell
        cell.ngayktLabel.text = searchTableView[indexPath.row].ngaykt
        cell.ngaybdLabel.text = searchTableView[indexPath.row].ngaybd
        cell.diadiemLabel.text = searchTableView[indexPath.row].diadiem
        cell.tieudeLbael.text = searchTableView[indexPath.row].tieude
        cell.manvLabel.text = searchTableView[indexPath.row].nhanvien
        cell.noidungLabel.text = searchTableView[indexPath.row].noidung
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboad = UIStoryboard(name: "InfoScheduleController", bundle: nil)
        if let vc = storyboad.instantiateViewController(withIdentifier: "InfoScheduleController") as? InfoScheduleController {
            vc.malh = searchTableView[indexPath.row].malh
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ListScheduleController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let storyboad = UIStoryboard(name: "EditScheduleController", bundle: nil)
                if let vc = storyboad.instantiateViewController(withIdentifier: "EditSchedulesController") as? EditSchedulesController {
                    vc.malh = self.searchTableView[indexPath.row].malh
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
                            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                                let param: Parameters = ["method": "scheduedelete","malh": self.searchTableView[indexPath.row].malh , "seckey": urlRegister.last!.seckey!]
                                let paramAlarm: Parameters = ["method": "stopalarm","manv":entity.last!.manv!,"malh":self.searchTableView[indexPath.row].malh,"seckey":urlRegister.last!.seckey!]
                                self.deleteRows(paramer: param, indexPath: indexPath.row, paramAlram: paramAlarm)
                            }
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
            return[delete,edit]
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
    
    func stopAlarm(param: Parameters!) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        if let valueString = response.result.value as? [String: Any] {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                    
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
    
    func deleteRows(paramer: Parameters!, indexPath: Int, paramAlram: Parameters!) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramer, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        if let valueString = response.result.value as? [String: Any] {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                    SVProgressHUD.show()
                                    self.schedule.remove(at: indexPath)
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.stopAlarm(param: paramAlram)
                                        self.requestData()
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
    
    func requestData() {
        //Lấy dữ liệu từ coreData
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    let param: Parameters = ["method":"schedules","manv": entity.last!.manv!,"seckey":urlRegister.last!.seckey!]
                    print(param)
                    ScheduleRequest.getSchedules(parameter: param) { [unowned self] (schedule) in
                        self.schedule = schedule
                        self.searchTableView = self.schedule
                        self.tableView.reloadData()
                    }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
