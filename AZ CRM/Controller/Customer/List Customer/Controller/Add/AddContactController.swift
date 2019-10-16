//
//  AddContactController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SVProgressHUD

class AddContactController: BaseViewController {
    
    @IBOutlet weak var malhTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cvuTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var didongTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var didongkhacTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var dienthoaiTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var buttonTrainsion: UIButton!
    
    var maKhTextFieldKH: String?
    var nameTextFieldKH: String?
    var mailTextFieldKH: String?
    var telTextFieldKH: String?
    var phoneTextFieldKH: String?
    var skypeTextFieldKH: String?
    var fbTextFieldKH: String?
    var noteTextFieldKH: String?
    var dateLabelKH: String?
    var ngaydkkdKH: String?
    var diachiKH: String?
    var canhan: String?
    var manguonKH: Int?
    var mankhKH: Int?
    
    var smsBool: Bool?
    var isdaily: Bool?
    var ismail: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonTrainsion.cornerRadius = 25
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        self.requestCode()
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCustomerButton(_ sender: Any) {
        
        let messageDictionary = ["maso": "\(malhTextField.text ?? "")","hoten": "\(nameTextField.text ?? "")","chucvu": "\(cvuTextField.text ?? "")" ,"diachi": "\(addressTextField.text ?? "")","email": "\(mailTextField.text ?? "")","didong": "\(didongTextField.text ?? "")","didongkhac": "\(didongkhacTextField.text ?? "")","dienthoai": "\(dienthoaiTextField.text ?? "")"]
        
        if nameTextField.text != "" ,cvuTextField.text != "", addressTextField.text != "", mailTextField.text != "", didongTextField.text != "", didongkhacTextField.text != "", dienthoaiTextField.text != "" {
            if canhan == "Cá nhân" {
                // Lấy dữ liệu từ coreData
                do {
                    if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let paramAdd: Parameters = ["method":"customeraddorupdate", "themmoi":"true", "canhan": "true", "manv": entity.last!.manv!, "tenviettat": "\(maKhTextFieldKH!)", "tenkh": "\(nameTextFieldKH!)", "email": mailTextFieldKH ?? "", "dienthoai": "\(telTextFieldKH ?? "")", "didong": phoneTextFieldKH ?? "", "skype":"\(skypeTextFieldKH ?? "")", "facebook":"\(fbTextFieldKH ?? "")", "ghichu":"\(noteTextFieldKH ?? "")","manguon": manguonKH ?? 0,"mankh": mankhKH ?? 0 ,"issms":smsBool!,"ismail":ismail!, "isdaily":isdaily!,"ngaysinh":dateLabelKH ?? "","ngaydkkd":ngaydkkdKH ?? "","diachi":diachiKH ?? "","lhc": messageDictionary,"seckey":urlRegister.last!.seckey!]
                            print(paramAdd)
                            addCustomer(param: paramAdd)
                        }
                    }
                } catch  {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            } else {
                // Lấy dữ liệu từ coreData
                do {
                    if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let paramAdd: Parameters = ["method":"customeraddorupdate", "themmoi":"true", "canhan": "false", "manv": entity.last!.manv!, "tenviettat": "\(maKhTextFieldKH!)", "tenkh": "\(nameTextFieldKH!)", "email": mailTextFieldKH ?? "", "dienthoai": "\(telTextFieldKH ?? "")", "didong": phoneTextFieldKH ?? "", "skype":"\(skypeTextFieldKH ?? "")", "facebook":"\(fbTextFieldKH ?? "")", "ghichu":"\(noteTextFieldKH ?? "")","manguon": manguonKH ?? 0,"mankh": mankhKH ?? 0,"issms":smsBool!,"ismail":ismail!, "isdaily":isdaily!,"ngaysinh":dateLabelKH ?? "","ngaydkkd":ngaydkkdKH ?? "","diachi":diachiKH ?? "","lhc": messageDictionary,"seckey":urlRegister.last!.seckey!]
                            print(paramAdd)
                            addCustomer(param: paramAdd)
                        }
                    }
                } catch  {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension AddContactController {
    func addCustomer(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            if let message = valueString["msg"] as? String {
                                
                                if message == "ok" {
                                    SVProgressHUD.show()
                                    SVProgressHUD.setStatus("Thành công")
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        print(valueString)
                                        CheckPerform.shared.checkDismis = true
                                        self.dismiss(animated: true, completion: nil)
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
    
    func requestCode() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "contactcode","seckey": urlRegister.last!.seckey!]
                
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        if let valueString = response.result.value as? [String: Any] {
                            let valueCode = valueString["data"] as? String
                            self.malhTextField.text = valueCode
                        }
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

