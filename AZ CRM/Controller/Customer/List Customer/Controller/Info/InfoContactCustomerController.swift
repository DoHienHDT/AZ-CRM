//
//  InfoContactCustomerController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD

class InfoContactCustomerController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addImage: UIImageView!
    
    var contaclist = [ContactCustomer]()
    var makh: Int?
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomerDetailCell", bundle: nil), forCellReuseIdentifier: "customerDetail")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addImage.layer.cornerRadius = addImage.frame.height/2
        addImage.layer.shadowRadius = 20
        addImage.layer.shadowOpacity = 0.8
        addImage.layer.shadowColor = UIColor.black.cgColor
        addImage.layer.shadowOffset = CGSize.zero
        
        addImage.generateEllipticalShadow()
        
        requetsContact()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddContactCustomerController {
            vc.makh = makh
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contaclist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerDetail", for: indexPath) as! CustomerDetailCell
        cell.fullNameLabel.text = contaclist[indexPath.row].name
        cell.mailLabel.text = contaclist[indexPath.row].mail
        cell.phoneLabel.text = contaclist[indexPath.row].tel
        cell.malhLabel.text = contaclist[indexPath.row].maso
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func requetsContact() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                SVProgressHUD.show()
                let param: Parameters = ["method": "customer", "makh": makh ?? "","seckey": urlRegister.last!.seckey!]
                RequestContactCustomer.getContactCustomer(parameters: param) { (contact) in
                    self.contaclist = contact
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension InfoContactCustomerController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let mailCustomer = contaclist[indexPath.row]
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
                guard let number = URL(string: "tel://" + mailCustomer.tel) else { return }
                UIApplication.shared.open(number)
            }
            
            configure(action: call, with: .call)
            return [mail, call]
        } else {
            
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                let storyboard = UIStoryboard(name: "ListContact", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "EditContact") as? EditContactController {
                    vc.malh = self.contaclist[indexPath.row].malh
                    vc.makh = self.makh
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            configure(action: edit, with: .edit)
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let openActionCancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
                let openActionDelete = UIAlertAction(title: "Xoá", style: .destructive, handler: { (_) in
                    do {
                        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let param: Parameters = ["method": "contactdelete","malh": Int(self.contaclist[indexPath.row].malh) , "seckey": urlRegister.last!.seckey!]
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
            
            return[edit,delete]
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
                                    
                                    self.contaclist.remove(at: indexPath)
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.requetsContact()
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


