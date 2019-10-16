//
//  AddCustomerController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SVProgressHUD

class AddCustomerController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var canhanLabel: UILabel!
    @IBOutlet weak var nhomKhLabel: UILabel!
    @IBOutlet weak var nguonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ngaydkkdLabel: UILabel!
    
    @IBOutlet weak var diachiTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var maKhTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var telTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var skypeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fbTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var noteTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var buttonTriansion: UIButton!
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    var textFields: [SkyFloatingLabelTextField] = []
    let lightGreyColor: UIColor = UIColor(red: 197 / 255, green: 205 / 255, blue: 205 / 255, alpha: 1.0)
    let darkGreyColor: UIColor = UIColor(red: 52 / 255, green: 42 / 255, blue: 61 / 255, alpha: 1.0)
    let overcastBlueColor: UIColor = UIColor(red: 0, green: 187 / 255, blue: 204 / 255, alpha: 1.0)
    
    var smsBool: Bool = false
    var mailBool: Bool = false
    var dailyL: Bool = false
    
    var manguon: Int?
    var mankh: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        buttonTriansion.cornerRadius = 25
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                    topButton.constant = CGFloat(entity.last!.heightTopButton)
                    heightTitle.constant = CGFloat(entity.last!.heightTitle)
                    topButtonRight.constant = CGFloat(entity.last!.heightTopButtonRight)
                    
                    let param: Parameters = ["method": "customergroups","seckey": urlRegister.last!.seckey!]
                    RequestGroups.getManhom(parameters: param, completionHandler: { [unowned self] (manhomValue) in
                        for value in manhomValue {
                            self.nhomKhLabel.text = value.manhom[1]
                            self.mankh = Int(value.manhom[0])
                        }
                    })
                    
                    let paramManguon: Parameters = ["method": "customersources","seckey": urlRegister.last!.seckey!]
                    RequestGroups.getManguon(parameters: paramManguon, completionHandler: { [unowned self] (manguonValue) in
                        for value in manguonValue {
                            self.nguonLabel.text = value.manguon[1]
                            self.manguon = Int(value.manguon[0])
                        }
                    })
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        CheckPerform.shared.checkDismis = false
        
        requestCode()
        textFields = [maKhTextField, nameTextField, phoneTextField, mailTextField]
        
        for textField in textFields {
            textField.delegate = self
        }
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
        maKhTextField.becomeFirstResponder()
        self.setupUser()
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckPerform.shared.checkDismis == true {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVc = segue.destination as? AddContactController {
            detailVc.maKhTextFieldKH = maKhTextField.text
            detailVc.nameTextFieldKH = nameTextField.text
            detailVc.mailTextFieldKH = mailTextField.text
            detailVc.telTextFieldKH = telTextField.text
            detailVc.phoneTextFieldKH = phoneTextField.text
            detailVc.skypeTextFieldKH = skypeTextField.text
            detailVc.fbTextFieldKH = fbTextField.text
            detailVc.noteTextFieldKH = noteTextField.text
            detailVc.manguonKH = manguon
            detailVc.mankhKH = mankh
            detailVc.smsBool = smsBool
            detailVc.isdaily = dailyL
            detailVc.ismail = mailBool
            detailVc.dateLabelKH = dateLabel.text
            detailVc.canhan = canhanLabel.text
            detailVc.ngaydkkdKH = ngaydkkdLabel.text
            detailVc.diachiKH = diachiTextField.text
        }
    }
    
    @IBAction func canhanAlertButton(_ sender: Any) {
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
    
    @IBAction func nhomKHAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customerGroups) { (info) in
            self.nhomKhLabel.text = info?.customerGroups[1] ?? ""
            self.mankh = Int(info!.customerGroups[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func smsButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        smsBool = sender.isSelected
    }
    
    @IBAction func emailButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        mailBool = sender.isSelected
    }
    
    @IBAction func dailyButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        dailyL = sender.isSelected
    }
    
    @IBAction func nguonAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customersources) { (info) in
            self.nguonLabel.text = info?.customersources[1] ?? ""
            self.manguon = Int(info!.customersources[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dateAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.dateLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày sinh", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.dateLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)

        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.dateLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCustomerButton(_ sender: UIButton) {
        if maKhTextField.text != "", nameTextField.text != ""{
            if canhanLabel.text == "Tổ chức" {
                //Lấy dữ liệu từ coreData
                if phoneTextField.text != "" || mailTextField.text != "" {
                    do {
                        if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                                let param: Parameters = ["method":"customeraddorupdate", "themmoi":"true", "canhan": "false", "manv": entity.last!.manv!, "tenviettat": "\(maKhTextField.text!)", "tenkh": "\(nameTextField.text!)", "email": mailTextField.text ?? "", "dienthoai": "\(telTextField.text ?? "")", "didong": phoneTextField.text ?? "", "skype":"\(skypeTextField.text ?? "")", "facebook":"\(fbTextField.text ?? "")", "ghichu":"\(noteTextField.text ?? "")","manguon": manguon ?? 0,"mankh": mankh ?? 0,"ismail":mailBool,"issms":smsBool,"isdaily":dailyL,"ngaysinh":dateLabel.text ?? "","diachi":diachiTextField.text ?? "","ngaydkkd":ngaydkkdLabel.text ?? "","seckey":urlRegister.last!.seckey!]
                                
                                addCustomer(param: param)
                            }
                        }
                    } catch  {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                } else {
                    let alert = UIAlertController(title: "Cần nhập đủ dữ liệu email hoặc di động", message: nil, preferredStyle: .alert)
                    let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
                    alert.addAction(openAction)
                    present(alert, animated: true, completion: nil)
                }
            } else {
                //Lấy dữ liệu từ coreData
                if phoneTextField.text != "" || mailTextField.text != "" {
                    do {
                        if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                                let param: Parameters = ["method":"customeraddorupdate", "themmoi":"true", "canhan": "true", "manv": entity.last!.manv!, "tenviettat": "\(maKhTextField.text!)", "tenkh": "\(nameTextField.text!)", "email": mailTextField.text ?? "", "dienthoai": "\(telTextField.text ?? "")", "didong": phoneTextField.text ?? "", "skype":"\(skypeTextField.text ?? "")", "facebook":"\(fbTextField.text ?? "")", "ghichu":"\(noteTextField.text ?? "")","manguon": manguon ?? 0,"mankh": mankh ?? 0,"ismail":mailBool,"issms":smsBool,"isdaily":dailyL,"ngaysinh":dateLabel.text ?? "","diachi":diachiTextField.text ?? "","ngaydkkd":ngaydkkdLabel.text ?? "","seckey":urlRegister.last!.seckey!]
                                print(param)
                                addCustomer(param: param)
                            }
                        }
                    } catch  {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
                else {
                    let alert = UIAlertController(title: "Cần nhập đủ dữ liệu email hoặc di động", message: nil, preferredStyle: .alert)
                    let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
                    alert.addAction(openAction)
                    present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addContactButton(_ sender: Any) {
        if maKhTextField.text != "", nameTextField.text != ""{
            self.performSegue(withIdentifier: "addContactCustomer", sender: self)
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "Đã Hiểu", style: .cancel, handler: nil)
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func ngaydkkdAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngaydkkdLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày đăng ký kinh doanh", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaydkkdLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaydkkdLabel.text =  " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
}

extension AddCustomerController {
    func setupUser() {
        
        maKhTextField.placeholder = NSLocalizedString(
            "Mã khách hàng",
            tableName: "SkyFloatingLabelTextField",
            comment: "placeholder for person title field"
        )
        maKhTextField.selectedTitle = NSLocalizedString(
            "Mã khách hàng",
            tableName: "SkyFloatingLabelTextField",
            comment: "selected title for person title field"
        )
        maKhTextField.title = NSLocalizedString(
            "Mã khách hàng",
            tableName: "SkyFloatingLabelTextField",
            comment: "title for person title field"
        )
        
        nameTextField.placeholder = NSLocalizedString(
            "Tên khách hàng",
            tableName: "SkyFloatingLabelTextField",
            comment: "placeholder for traveler name field"
        )
        nameTextField.selectedTitle = NSLocalizedString(
            "Tên khách hàng",
            tableName: "SkyFloatingLabelTextField",
            comment: "selected title for traveler name field"
        )
        nameTextField.title = NSLocalizedString(
            "Tên khách hàng",
            tableName: "SkyFloatingLabelTextField",
            comment: "title for traveler name field"
        )
        
        phoneTextField.placeholder = NSLocalizedString(
            "Di động",
            tableName: "SkyFloatingLabelTextField",
            comment: "placeholder for Email field"
        )
        phoneTextField.selectedTitle = NSLocalizedString(
            "Di động",
            tableName: "SkyFloatingLabelTextField",
            comment: "selected title for Email field"
        )
        phoneTextField.title = NSLocalizedString(
            "Di động",
            tableName: "SkyFloatingLabelTextField",
            comment: "title for Email field"
        )
        
        mailTextField.placeholder = NSLocalizedString(
            "Email",
            tableName: "SkyFloatingLabelTextField",
            comment: "placeholder for Email field"
        )
        mailTextField.selectedTitle = NSLocalizedString(
            "Email",
            tableName: "SkyFloatingLabelTextField",
            comment: "selected title for Email field"
        )
        mailTextField.title = NSLocalizedString(
            "Email",
            tableName: "SkyFloatingLabelTextField",
            comment: "title for Email field"
        )
        
        applySkyscannerTheme(textField: mailTextField)
        applySkyscannerTheme(textField: phoneTextField)
        applySkyscannerTheme(textField: nameTextField)
        applySkyscannerTheme(textField: maKhTextField)
        
    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        
        textField.tintColor = overcastBlueColor
        
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Validate the email field
        if textField == mailTextField {
            validateEmailField()
        }
        
        // When pressing return, move to the next field
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func validateEmailField() {
        validateEmailTextFieldWithText(email: mailTextField.text)
    }
    
    func validateEmailTextFieldWithText(email: String?) {
        guard let email = email else {
            mailTextField.errorMessage = nil
            return
        }
        
        if email.isEmpty {
            mailTextField.errorMessage = nil
        } else if !validateEmail(email) {
            mailTextField.errorMessage = NSLocalizedString(
                "Email not valid",
                tableName: "SkyFloatingLabelTextField",
                comment: " "
            )
        } else {
            mailTextField.errorMessage = nil
        }
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        
        // NOTE: validating email addresses with regex is usually not the best idea.
        // This implementation is for demonstration purposes only and is not recommended for production use.
        // Regex source and more information here: http://emailregex.com
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func requestCode() {
        
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "custcode","seckey": urlRegister.last!.seckey!]
                
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        if let valueString = response.result.value as? [String: Any] {
                            let valueCode = valueString["data"] as? String
                            self.maKhTextField.text = valueCode
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
}

