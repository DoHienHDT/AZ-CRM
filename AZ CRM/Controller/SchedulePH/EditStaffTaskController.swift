//
//  EditStaffTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import Alamofire

class EditStaffTaskController: BaseViewController {

    @IBOutlet weak var mavtLabel: UILabel!
    @IBOutlet weak var manvLabel: UILabel!
    @IBOutlet weak var diengiaiTextField: UITextField!
    @IBOutlet weak var buttonTrainsion: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    var id: Int?
    var macv: Int?
    var mavt: Int?
    var manv: Int?

    var makh: Int?
    var malcv: Int?
    var matt: Int?
    var mamd: Int?
    var ngaykt: String?
    var ngaybd: String?
    var diengiai: String?
    var tencv: String?
    
    var myArrayStaff = [[String: Any]]()
    
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

        buttonTrainsion.cornerRadius = 20
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        requestData()
    }
    
    deinit {
       Log("has deinitialized")
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func mavtAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .tasktitles) { [unowned self] (info) in
            self.mavtLabel.text = info?.tasktitles[1]
            self.mavt = Int(info!.tasktitles[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func manvAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .staff) { [unowned self] (info) in
            self.manvLabel.text = info?.staff[1]
            self.manv = Int(info!.staff[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func editSuccessButton(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        if manvLabel.text != " ",mavtLabel.text != " " {
            let dictionary = [
                "id": id!,
                "manv": manv!,
                "mavt": mavt!,
                "diengiai": diengiaiTextField.text ?? ""
                ] as [String : Any]
            myArrayStaff.append(dictionary)
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    
                    let param: Parameters = ["method":"taskaddorupdate","themmoi":"false","manv":entity.last!.manv!,"makh":self.makh!,"ngaybd":self.ngaybd!,"macv":self.macv!, "ngaykt":self.ngaykt!, "malcv":self.malcv!, "matt":self.matt!, "mamd":self.mamd!, "diengiai":self.diengiai ?? "", "tencv":self.tencv!, "nhanviens":self.myArrayStaff, "seckey":urlRegister.last!.seckey!]
                    self.editStaff(param: param)
                 }
               }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension EditStaffTaskController {
    func requestData() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                InfoTaskRequest.getInfoStaffTask(parameter: param) { (infoStaffTask) in
                    for value in infoStaffTask {
                        if value.id == self.id {
                            self.mavtLabel.text = value.mavt
                            self.manvLabel.text = value.manv
                            self.diengiaiTextField.text = value.diengiai
                            
                            self.mavt = value.mavtInt
                            self.manv = value.manvInt
                        } else {
                            let dictionary = [
                                "manv": value.manvInt,
                                "mavt": value.mavtInt,
                                "diengiai": value.diengiai
                                ] as [String : Any]
                            self.myArrayStaff.append(dictionary)
                        }
                    }
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
                               
                                    SVProgressHUD.setStatus("Thành công")
                                    SVProgressHUD.dismiss(withDelay: 2, completion: {
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                } else {
                                    SVProgressHUD.dismiss()
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
}

