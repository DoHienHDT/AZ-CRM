//
//  EditCustomerController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift

class EditCustomerController: BaseViewController , UITextFieldDelegate{
    
    @IBOutlet weak var makhTextfield: UITextField!
    @IBOutlet weak var nkhLabel: UILabel!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var telTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var skypeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fbTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var noteTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nguonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var canhanLabel: UILabel!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var ngaydkkdLabel: UILabel!
    @IBOutlet weak var trainsionButton: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var makh: Int?
    var canhanBool: Bool?
    var manhom: Int?
    var manguon: Int?
    var malhc: Int?
    var smsBool: Bool = false
    var mailBool: Bool = false
    var dailyL: Bool = false
    var ngaysinh: String?
    var ngaydkkd: String?
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainsionButton.cornerRadius = 25
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                    topButton.constant = CGFloat(entity.last!.heightTopButton)
                    heightTitle.constant = CGFloat(entity.last!.heightTitle)
                    topButtonRight.constant = CGFloat(entity.last!.heightTopButtonRight)
                    
                    if makh != nil {
                        
                        let param: Parameters = ["method": "customer", "makh": makh!,"seckey": urlRegister.last!.seckey!]
                        RequestInfoCustomer.getInforCustomer(parameter: param) { [unowned self] (infor) in
                            
                            for inforCustomer in infor {
                                
                                self.makhTextfield.text = inforCustomer.abbreviations
                                self.nameTextField.text = inforCustomer.userName
                                self.phoneTextField.text = inforCustomer.tel
                                self.telTextField.text = inforCustomer.mobile
                                self.mailTextField.text = inforCustomer.email
                                self.skypeTextField.text = inforCustomer.skype
                                self.fbTextField.text = inforCustomer.facebook
                                self.noteTextField.text = inforCustomer.note
                                self.dateLabel.text = inforCustomer.ngaysinh
                                self.ngaysinh = inforCustomer.ngaysinh
                                self.ngaydkkd = inforCustomer.ngaydkkd
                                self.ngaydkkdLabel.text = inforCustomer.ngaydkkd
                                self.addressTextField.text = inforCustomer.diachi
                                self.canhanBool = inforCustomer.canhan
                                self.manhom = inforCustomer.manhom
                                self.manguon = inforCustomer.manguon
                                self.smsButton.isSelected = inforCustomer.issms
                                self.smsBool = inforCustomer.issms
                                self.mailButton.isSelected = inforCustomer.isemail
                                self.mailBool = inforCustomer.isemail
                                self.dailyButton.isSelected = inforCustomer.isdaily
                                self.dailyL = inforCustomer.isdaily
                                
                                if self.canhanBool == true {
                                    self.canhanLabel.text = "Cá nhân"
                                } else {
                                    self.canhanLabel.text = "Tổ chức"
                                }
                                
                                // lấy mã nhóm theo thông số lấy về
                                if self.manhom != 0 {
                                    
                                    let param: Parameters = ["method": "customergroups","seckey": urlRegister.last!.seckey!]
                                    RequestGroups.getManhom(parameters: param, completionHandler: { [unowned self] (manhomValue) in
                                        for value in manhomValue {
                                            if self.manhom == Int(value.manhom[0]) {
                                                self.nkhLabel.text = value.manhom[1]
                                            }
                                        }
                                    })
                                }
                                
                                // lấy mã nhóm theo thông số lấy về
                                if self.manguon != 0 {
                                    let param: Parameters = ["method": "customersources","seckey": urlRegister.last!.seckey!]
                                    RequestGroups.getManguon(parameters: param, completionHandler: { [unowned self] (manguonValue) in
                                        for value in manguonValue {
                                            if self.manguon == Int(value.manguon[0]) {
                                                self.nguonLabel.text = value.manguon[1]
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        CheckPerform.shared.checkDismis = false
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmisTextField))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckPerform.shared.checkDismis == true {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.endEditing(true)
    }
    
    @objc func dissmisTextField() {
        view.endEditing(true)
    }
    
    @IBAction func phanloaiKHButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction1 = UIAlertAction(title: "Tổ chức", style: .destructive) { (text) in
            self.canhanLabel.text = "Tổ chức"
        }
        
        let openAction2 = UIAlertAction(title: "Cá nhân", style: .destructive) { (text) in
            self.canhanLabel.text = "Cá nhân"
        }
        
        alert.addAction(openAction)
        alert.addAction(openAction1)
        alert.addAction(openAction2)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func nhomKHButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customerGroups) { [unowned self] (info) in
            self.nkhLabel.text = info?.customerGroups[1] ?? ""
            self.manhom = Int(info!.customerGroups[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dateAlertButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Ngày sinh", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.dateLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.dateLabel.text = self.ngaysinh ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func ngaydkkdAlertButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Ngày đăng ký kinh doanh", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaydkkdLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaydkkdLabel.text = self.ngaydkkd ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func nguonAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customersources) { [unowned self] (info) in
            self.nguonLabel.text = info?.customersources[1] ?? ""
            self.manguon = Int(info!.customersources[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editCustomerButton(_ sender: UIButton) {
        SVProgressHUD.show()
        if makhTextfield.text != "", nameTextField.text != ""{
            if canhanLabel.text == "Tổ chức" {
                // Lấy dữ liệu từ coreData
                do {
                    if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                        if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                            let param: Parameters = ["method":"customeraddorupdate", "themmoi":"false", "canhan": "false","makh": makh!, "manv": entity.last!.manv!, "tenviettat": "\(makhTextfield.text!)", "tenkh": "\(nameTextField.text!)", "email": mailTextField.text ?? "", "dienthoai": phoneTextField.text ?? "", "didong": telTextField.text ?? "", "skype":"\(skypeTextField.text ?? "")", "facebook":"\(fbTextField.text ?? "")", "ghichu":"\(noteTextField.text ?? "")","manguon": manguon ?? 0,"mankh": manhom ?? 0 ,"ismail":mailBool,"issms":smsBool,"isdaily":dailyL,"ngaysinh":dateLabel.text ?? "","diachi":addressTextField.text ?? "","ngaydkkd":ngaydkkdLabel.text ?? "","seckey":urlRegister.last!.seckey!]
                            print(param)
                            updateCustomer(param: param)
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
                            let param: Parameters = ["method":"customeraddorupdate", "themmoi":"false", "canhan": "true","makh": makh!, "manv": entity.last!.manv!, "tenviettat": "\(makhTextfield.text!)", "tenkh": "\(nameTextField.text!)", "email": mailTextField.text ?? "", "dienthoai": phoneTextField.text ?? "", "didong": telTextField.text ?? "", "skype":"\(skypeTextField.text ?? "")", "facebook":"\(fbTextField.text ?? "")", "ghichu":"\(noteTextField.text ?? "")","manguon": manguon ?? 0,"mankh": manhom ?? 0 ,"ismail":mailBool,"issms":smsBool,"isdaily":dailyL,"ngaysinh":dateLabel.text
                                ?? "","diachi":addressTextField.text ?? "","ngaydkkd":ngaydkkdLabel.text ?? "","seckey":urlRegister.last!.seckey!]
                            
                            updateCustomer(param: param)
                        }
                    }
                } catch  {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
            
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func smsButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        smsBool = sender.isSelected
    }
    
    @IBAction func mailButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        mailBool = sender.isSelected
    }
    
    @IBAction func dailyButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        dailyL = sender.isSelected
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editLhcButton(_ sender: Any) {
        if makhTextfield.text != "", nameTextField.text != "", phoneTextField.text != "", mailTextField.text != ""  {
            do {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    let param: Parameters = ["method": "customer", "makh": makh!,"seckey": urlRegister.last!.seckey!]
                    RequestInfoCustomer.getInforCustomer(parameter: param) { [unowned self] (infor) in
                        for inforCustomer in infor {
                            self.malhc = inforCustomer.malhc
                            if self.malhc != nil {
                                RequestContactCustomer.getContactCustomer(parameters: param, completionHandler: { (malhcContact) in
                                    var count = 0
                                    for value in malhcContact {
                                        if self.malhc == value.malh {
                                            count += 1
                                            if let storyboard = self.storyboard {
                                                if let vc = storyboard.instantiateViewController(withIdentifier: "EditContactLHCController") as? EditContactLHCController {
                                                    vc.makh = self.makh
                                                    vc.malhc = self.malhc
                                                    vc.maKhTextFieldKH = self.makhTextfield.text
                                                    vc.nameTextFieldKH = self.nameTextField.text
                                                    vc.mailTextFieldKH = self.mailTextField.text
                                                    vc.telTextFieldKH = self.telTextField.text
                                                    vc.phoneTextFieldKH = self.phoneTextField.text
                                                    vc.addressTextFieldKH = self.addressTextField.text
                                                    vc.skypeTextFieldKH = self.skypeTextField.text
                                                    vc.fbTextFieldKH = self.fbTextField.text
                                                    vc.noteTextFieldKH = self.noteTextField.text
                                                    vc.dateLabelKH = self.dateLabel.text
                                                    vc.ngaydkkdKH = self.ngaydkkdLabel.text
                                                    vc.canhan = self.canhanLabel.text
                                                    vc.manguonKH = self.manguon
                                                    vc.mankhKH = self.manhom
                                                    vc.smsBool = self.smsBool
                                                    vc.ismail = self.mailBool
                                                    vc.isdaily = self.dailyL
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                }
                                            }
                                        }
                                    }
                                    if count == 0 {
                                        let alert = UIAlertController(title: nil, message: "Không có liên hệ chính", preferredStyle: .actionSheet)
                                        
                                        alert.addAction(title: "Thêm liên hệ chính") { (_) in
                                            if let storyboard = self.storyboard {
                                                if let vc = storyboard.instantiateViewController(withIdentifier: "AddContactLHCController") as? AddContactLHCController {
                                                    vc.addLHC = 1
                                                    vc.makh = self.makh
                                                    vc.maKhTextFieldKH = self.makhTextfield.text
                                                    vc.nameTextFieldKH = self.nameTextField.text
                                                    vc.mailTextFieldKH = self.mailTextField.text
                                                    vc.telTextFieldKH = self.telTextField.text
                                                    vc.phoneTextFieldKH = self.phoneTextField.text
                                                    vc.addressTextFieldKH = self.addressTextField.text
                                                    vc.skypeTextFieldKH = self.skypeTextField.text
                                                    vc.fbTextFieldKH = self.fbTextField.text
                                                    vc.noteTextFieldKH = self.noteTextField.text
                                                    vc.dateLabelKH = self.dateLabel.text
                                                    vc.canhan = self.canhanLabel.text
                                                    vc.manguonKH = self.manguon
                                                    vc.mankhKH = self.manhom
                                                    vc.smsBool = self.smsBool
                                                    vc.ismail = self.mailBool
                                                    vc.isdaily = self.dailyL
                                                    vc.ngaydkkdKH = self.ngaydkkdLabel.text
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                }
                                            }
                                        }
                                        alert.addAction(title: "Cancel")
                                        
                                        self.present(alert, animated: true, completion: nil)
                                    } else {
                                        print(count)
                                    }
                                })
                            }
                        }
                    }
             
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
            
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension EditCustomerController {
    func updateCustomer(param: Parameters) {
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
                                        
                                        self.navigationController?.popViewController(animated: true)
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
}

