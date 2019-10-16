//
//  ContactViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class ContactViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var contacts = [ContactModel]()
    var searchTableView = [ContactModel]()
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightLabel: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightLabel.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        navigationView.dropShadow()
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        
        SVProgressHUD.show()
        tableView.register(UINib(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: "contactListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @IBAction func addContactButton(_ sender: Any) {
        if let storyboad = self.storyboard {
            if let vc = storyboad.instantiateViewController(withIdentifier: "AddContactControllerLH") as? AddContactControllerLH {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchTableView = contacts
            tableView.reloadData()
            return
        }
        print(searchText)
        
       searchTableView = contacts.filter({ (infoList) -> Bool in
            infoList.tenkh.lowercased().contains(searchText.lowercased()) || infoList.maso.lowercased().contains(searchText.lowercased()) ||
                    infoList.mail.lowercased().contains(searchText.lowercased()) ||
                        infoList.phone.lowercased().contains(searchText.lowercased()) ||
                            infoList.company.lowercased().contains(searchText.lowercased())
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
        searchTableView = contacts
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
            self.request()
            self.refreshControl.endRefreshing()
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCell", for: indexPath) as! ContactListTableViewCell
            cell.mailLabel.text = searchTableView[indexPath.row].mail
            cell.malhLabel.text = searchTableView[indexPath.row].maso
            cell.nameLabel.text = searchTableView[indexPath.row].company
            cell.companyLabel.text = searchTableView[indexPath.row].tenkh
            cell.phoneLabel.text =  searchTableView[indexPath.row].phone
            cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ListContact", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "infoContact") as? InfoContactController {
            vc.malh = searchTableView[indexPath.row].malh
            vc.makh = searchTableView[indexPath.row].tenkh
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func request() {
        
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
                    let param: Parameters = ["method": "contacts","rtype": entity.last!.rtype!,"isadmin":entity.last!.isadmin!,"mact":entity.last!.mact!,"manv":entity.last!.manv!,"mapb":entity.last!.mapb!,"mankd":entity.last!.mankd!,"tungay": "\(previousMonthString)","denngay":"\(dateString)","seckey": urlRegister.last!.seckey!]
                print(param)
                    RequestContacts.getContact(parameter: param) {  [unowned self] (contact) in
                        self.contacts = contact
                        self.searchTableView = self.contacts
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
}

extension ContactViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let mailCustomer = searchTableView[indexPath.row]
        
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
            return [call, mail]
        } else {

            let delete = SwipeAction(style: .destructive, title: nil) { (action, indexpath) in
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let openActionCancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
                let openActionDelete = UIAlertAction(title: "Xoá", style: .destructive, handler: { (_) in
                    
                    do {
                        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let param: Parameters = ["method": "contactdelete","malh": self.searchTableView[indexPath.row].malh , "seckey": urlRegister.last!.seckey!]
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
            
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let storyboard = UIStoryboard(name: "ListContact", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "EditContact") as? EditContactController {
                    vc.malh = self.contacts[indexPath.row].malh
                    vc.makh = self.contacts[indexPath.row].makh
                    vc.makhString = self.contacts[indexPath.row].tenkh
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            configure(action: edit, with: .edit)
       
            return [delete, edit]
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
                                    
                                    self.contacts.remove(at: indexPath)
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.request()
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
