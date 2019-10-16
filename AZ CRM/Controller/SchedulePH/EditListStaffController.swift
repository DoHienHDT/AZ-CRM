//
//  EditListStaffController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class EditListStaffController: BaseViewController, AddStaffTaskControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
   
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var imageAdd: UIImageView!
    
    var infoStaffTask = [InfoStaffTaskModel]()
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    var myArrayStaff = [[String: Any]]()
    var valueStringDelete = [[String: Any]]()
    var macv: Int?
    var makh: Int?
    var malcv: Int?
    var matt: Int?
    var mamd: Int?
    var ngaykt: String?
    var ngaybd: String?
    var diengiai: String?
    var tencv: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        imageAdd.layer.cornerRadius = imageAdd.frame.height/2
        imageAdd.layer.shadowRadius = 20
        imageAdd.layer.shadowOpacity = 0.8
        imageAdd.layer.shadowColor = UIColor.black.cgColor
        imageAdd.layer.shadowOffset = CGSize.zero
        
        imageAdd.generateEllipticalShadow()
        
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        requestData()
        tableView.register(UINib(nibName: "InfoStaffTaskCell", bundle: nil), forCellReuseIdentifier: "InfoStaffTaskCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    @IBAction func addStaffButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddTaskController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddStaffTaskController") as? AddStaffTaskController {
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func senData(vitri: String, nhanvien: String, diengiai: String, mavt: Int, manv: Int) {
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                self.myArrayStaff = []
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                InfoTaskRequest.getInfoStaffTask(parameter: param) { (infoStaffTask) in
                    
                    for value in infoStaffTask {
                        let dictionary = [
                            "manv": value.manvInt,
                            "mavt": value.mavtInt,
                            "diengiai": value.diengiai
                            ] as [String : Any]
                        self.myArrayStaff.append(dictionary)
                    }
                    
                    let dictionary = [
                        "manv": manv,
                        "mavt": mavt,
                        "diengiai": diengiai,
                        ] as [String : Any]
                    self.myArrayStaff.append(dictionary)
                    let paramEdit: Parameters = ["method":"taskaddorupdate","themmoi":"false","manv":entity.last!.manv!,"makh":self.makh ?? 0,"ngaybd":self.ngaybd  ?? "","macv":self.macv ?? 0, "ngaykt":self.ngaykt ?? "", "malcv":self.malcv  ?? 0, "matt":self.matt ?? 0, "mamd":self.mamd ?? 0, "diengiai":self.diengiai ?? "", "tencv":self.tencv ?? 0, "nhanviens":self.myArrayStaff, "seckey":urlRegister.last!.seckey!]
                    self.editStaff(param: paramEdit)
                }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension EditListStaffController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoStaffTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoStaffTaskCell", for: indexPath) as! InfoStaffTaskCell
        cell.manvLabel.text = infoStaffTask[indexPath.row].manv
        cell.mavtLabel.text = infoStaffTask[indexPath.row].mavt
        cell.diengiaiLabel.text = infoStaffTask[indexPath.row].diengiai
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

extension EditListStaffController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let edit = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                if let storyboad = self.storyboard {
                    if let vc = storyboad.instantiateViewController(withIdentifier: "EditStaffTaskController") as? EditStaffTaskController {
                        vc.id = self.infoStaffTask[indexPath.row].id
                        vc.macv = self.macv
                        vc.makh = self.makh
                        vc.malcv = self.malcv
                        vc.matt = self.matt
                        vc.mamd = self.mamd
                        vc.ngaykt = self.ngaykt
                        vc.ngaybd = self.ngaybd
                        vc.diengiai = self.diengiai
                        vc.tencv = self.tencv
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
            edit.hidesWhenSelected = true
            configure(action: edit, with: .edit)
            
            let delete = SwipeAction(style: .default, title: nil) { action, indexPath in
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let openActionCancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
                let openActionDelete = UIAlertAction(title: "Xoá", style: .destructive, handler: { (_) in
                    self.valueStringDelete = []
                    SVProgressHUD.show()
                    let id = self.infoStaffTask[indexPath.row].id
                    
                    for valueStaff in self.infoStaffTask {
                        if valueStaff.id != id {
                            let dictionary = [
                                "manv": valueStaff.manvInt,
                                "mavt": valueStaff.mavtInt,
                                "diengiai": valueStaff.diengiai
                                ] as [String : Any]
                            self.valueStringDelete.append(dictionary)
                        }
                    }
                    
                    do {
                        if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                              if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let param: Parameters = ["method":"taskaddorupdate","themmoi":"false","manv":entity.last!.manv!,"makh":self.makh!,"ngaybd":self.ngaybd!,"macv":self.macv!, "ngaykt":self.ngaykt!, "malcv":self.malcv!, "matt":self.matt!, "mamd":self.mamd!, "diengiai":self.diengiai ?? "", "tencv":self.tencv!, "nhanviens":self.valueStringDelete, "seckey":urlRegister.last!.seckey!]
                            self.editStaff(param: param)
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
}
extension EditListStaffController {
    func requestData() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                InfoTaskRequest.getInfoStaffTask(parameter: param) { (infoStaffTask) in
                    self.infoStaffTask = infoStaffTask
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func editStaff(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { [unowned self] (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            print("param edit Staff \n \(param)")
                            if let message = valueString["msg"] as? String {
                                
                                if message == "ok" {
                                    SVProgressHUD.show()
                                    SVProgressHUD.showSuccess(withStatus: "Thành công")
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.apiReloadTableViewStaff()
                                    })
                                } else {
                                    
                                    let alert = UIAlertController(title: nil, message: message.localizedLowercase, preferredStyle: .alert)
                                    let openAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                    alert.addAction(openAction)
                                    self.present(alert, animated: true, completion: nil)
                                    print("thieu")
                                }
                            }
                        }
                        break
                    case .failure( _):
                        break
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func apiReloadTableViewStaff() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                InfoTaskRequest.getInfoStaffTask(parameter: param) { [unowned self] (infoStaffTask) in
                    self.infoStaffTask = infoStaffTask
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
     
    }
}

