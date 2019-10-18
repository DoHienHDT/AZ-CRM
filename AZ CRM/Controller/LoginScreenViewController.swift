//
//  LoginScreenViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import IQKeyboardManagerSwift

struct Patient {
    var id: Int?
    var ten: String?
}

class LoginScreenViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dangnhapBt: UIButton!
    @IBOutlet weak var remmemberSw: UISwitch!
    @IBOutlet weak var matkhauTf: UITextField!
    @IBOutlet weak var companyCodeTextField: UITextField!
    @IBOutlet weak var taikhoanTf: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var companyButton1: UIButton!
    @IBOutlet weak var nextCompanyButton: UIButton!
    
    let linkUrl = "http://azsoft.vn/"
    var login: Int = 0
    let uuid = UUID().uuidString
    
    var offpatients = [Patient]()
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearAllFile()
        self.editScreen()
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        matkhauTf.delegate = self
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let userName = UserDefaults.standard.string(forKey: "userName")
        let pass = UserDefaults.standard.string(forKey: "passWord")
        
        if let companyCode = UserDefaults.standard.string(forKey: "companyCode") {
            
            if UserDefaults.standard.string(forKey: "userName") != nil {
                self.dismissKeyboard()
            } else {
                taikhoanTf.becomeFirstResponder()
            }
            
            companyCodeTextField.text = companyCode
            
            companyButton.isHidden = false
            companyButton1.isHidden = false
            nextCompanyButton.isHidden = true
            dangnhapBt.isHidden = false
            
            viewLogin.alpha = 1
            viewContact.alpha = 1
            viewCompany.alpha = 0
        } else {
            companyCodeTextField.becomeFirstResponder()
        }
        
        self.login = 0
        
        matkhauTf.text = pass
        taikhoanTf.text = userName
        remmemberSw.isOn = UserDefaults.standard.bool(forKey: "mySwitchValue")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.removeObject(forKey: "makhCustomerList")
        dismissKeyboard()
    }
    
    @IBAction func swichButton(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "mySwitchValue")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if login == 0 {
            self.login = 1
            SVProgressHUD.show()
            Alarm.alarm.stopAlarm()
            do {
                if let entity = try AppDelegate.context.fetch(FCToken.fetchRequest()) as? [FCToken] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        print(entity.last!.fcmToken!)
                        let parameters: Parameters = ["method": "login", "tendangnhap":taikhoanTf.text ?? "","matkhau":matkhauTf.text ?? "","tenmay":"iphone","ip":getWiFiAddress() ?? "" ,"deviceid":entity.last!.fcmToken!,"seckey": urlRegister.last!.seckey!]
                        print(parameters)
                        
                        registerRequest(url: urlRegister.last!.data!, parameter: parameters)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            dismissKeyboard()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if login == 0 {
            self.login = 1
            SVProgressHUD.show()
            Alarm.alarm.stopAlarm()
            do {
                if let entity = try AppDelegate.context.fetch(FCToken.fetchRequest()) as? [FCToken] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        print(entity.last!.fcmToken!)
                        let parameters: Parameters = ["method": "login", "tendangnhap":taikhoanTf.text ?? "","matkhau":matkhauTf.text ?? "","tenmay":"iphone","ip":getWiFiAddress() ?? "" ,"deviceid":entity.last!.fcmToken!,"seckey": urlRegister.last!.seckey!]
                        print(parameters)
                        
                        registerRequest(url: urlRegister.last!.data!, parameter: parameters)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            dismissKeyboard()
        }
        return true
    }
    
    @IBAction func lienheButton(_ sender: UIButton) {
        //            openUrl(url: linkUrl)
    }
    
    @IBAction func nextCompany(_ sender: UIButton) {
        self.requestCompany()
    }
    
    @IBAction func loginCodeCompany(_ sender: UIButton) {
        if let _ = UserDefaults.standard.string(forKey: "companyCode") {
            sender.isHidden = true
            companyButton.isHidden = true
            companyButton1.isHidden = true
            nextCompanyButton.isHidden = false
            dangnhapBt.isHidden = true
            
            viewLogin.fadeOut()
            viewContact.fadeOut()
            viewCompany.fadeIn()
        }
    }
}

extension LoginScreenViewController {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func editScreen() {
        self.nextCompanyButton.layer.cornerRadius = 30
        self.dangnhapBt.layer.cornerRadius = 30
    }
    
    func openUrl(url:String!) {
        let targetURL=URL.init(string: url)!
        let application=UIApplication.shared
        application.open(targetURL, options: [:], completionHandler: nil)
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    func saveDataContentApi() {
        saveDataApiStaff()
        saveDataApiProduct()
        saveDataApiTasktitles()
    }
    
    func convertAndSaveInDDPath (array:[Patient], fileName: String) {
        let objCArray = NSMutableArray()
        
        for obj in array {
            // we have to do something like this as we can't store struct objects directly in NSMutableArray
            let dict = NSDictionary(objects: [obj.id ?? 0,obj.ten ?? ""], forKeys: ["id" as NSCopying,"ten" as NSCopying])
            objCArray.add(dict)
        }
        
        // this line will save the array in document directory path.
        objCArray.write(toFile: getFilePath(fileName: fileName), atomically: true)
    }
    
    func getFilePath(fileName:String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(fileName)?.path
        return filePath!
    }
    
    func clearAllFile() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try fileManager.removeItem(at: myDocuments)
        }  catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveDataApiProduct() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let paramMatt: Parameters = ["method": "products","seckey": urlRegister.last!.seckey!]
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString = response.result.value as? [String: Any] {
                            if let data = valueString["data"] as? [[String: Any]] {
                                self.offpatients = []
                                for value in data {
                                    let id = value["id"] as? Int
                                    let masp = value["masp"] as? String
                                    let patient = Patient(id: id, ten: masp)
                                    self.offpatients.append(patient)
                                }
                                self.convertAndSaveInDDPath(array: self.offpatients, fileName: "ApiProduct")
                            }
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Lưu trữ dư liệu: \(error.localizedDescription)", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok",color:.red , style: .cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveDataApiStaff() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let paramManv: Parameters = ["method": "staffs","seckey": urlRegister.last!.seckey!]
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramManv, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString = response.result.value as? [String: Any] {
                            if let data = valueString["data"] as? [[String: Any]] {
                                self.offpatients = []
                                for value in data {
                                    let manvId = value["manv"] as? Int
                                    let hoten = value["hoten"] as? String
                                    let patient = Patient(id: manvId, ten: hoten)
                                    self.offpatients.append(patient)
                                }
                                self.convertAndSaveInDDPath(array: self.offpatients, fileName: "ApiStaff")
                            }
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Lưu trữ dư liệu: \(error.localizedDescription)", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok",color:.red,style: .cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveDataApiTasktitles() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let paramMatt: Parameters = ["method": "tasktitles","seckey": urlRegister.last!.seckey!]
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString = response.result.value as? [String: Any] {
                            if let data = valueString["data"] as? [[String: Any]] {
                                
                                self.offpatients = []
                                for value in data {
                                    let mavitri = value["mavitri"] as? Int
                                    let tenvitri = value["tenvitri"] as? String
                                    let patient = Patient(id: mavitri, ten: tenvitri)
                                    self.offpatients.append(patient)
                                }
                                self.convertAndSaveInDDPath(array: self.offpatients, fileName: "ApiTasktitles")
                            }
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Lưu trữ dư liệu : \(error.localizedDescription)", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok",color:.red,style: .cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func registerRequest(url: String!, parameter: Parameters!) {
        requestCompanyCodeLogin()
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if let valueString = response.result.value as? [String: Any] {
                if let message = valueString["msg"] as? String {
                    if message == "ok" {
                        
                        UserDefaults.standard.set(self.taikhoanTf.text, forKey: "taikhoan")
                        UserDefaults.standard.set(self.matkhauTf.text, forKey: "matkhau")
                        SVProgressHUD.showSuccess(withStatus: "Login success")
                        SVProgressHUD.dismiss()
                        
                        if UserDefaults.standard.bool(forKey: "mySwitchValue") == true {
                            UserDefaults.standard.set(self.taikhoanTf.text, forKey: "userName")
                            UserDefaults.standard.set(self.matkhauTf.text, forKey: "passWord")
                        } else {
                            UserDefaults.standard.removeObject(forKey: "userName")
                            UserDefaults.standard.removeObject(forKey: "passWord")
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            let entity = Entity(context: AppDelegate.context)
                            
                            let manv = valueString["manv"] as? String
                            let isadmin = valueString["isadmin"] as? Bool
                            let mact = valueString["mact"] as? String
                            let mapb = valueString["mapb"] as? String
                            let mankd = valueString["mankd"] as? String
                            
                            guard let dataHome = valueString["pers"] as? [String: Any] else {return}
                            print(dataHome.keys)
                            for i in dataHome.keys {
                                switch i {
                                case "khachhang":
                                    let khachhang = "khachhang"
                                    entity.quyenKH = khachhang
                                case "congviec":
                                    let congviec = "congviec"
                                    entity.quyenCV = congviec
                                case "lienhe":
                                    let lienhe = "lienhe"
                                    entity.quyenLH = lienhe
                                case "lichhen":
                                    let lichhen = "lichhen"
                                    entity.quyenLHen = lichhen
                                case "dathang":
                                    let dathang = "dathang"
                                    entity.quyenDH = dathang
                                case "cohoi":
                                    let cohoi = "cohoi"
                                    entity.quyenCH = cohoi
                                default:
                                    break
                                }
                            }
                            
                            switch UIDevice.modelName {
                            case "iPhone 6":
                                entity.heightNavigation = 80
                                entity.heightTitle = 35
                                entity.heightTopButton = 20
                                entity.heightTopButtonRight = 20
                            case "iPhone X":
                                entity.heightNavigation = 100
                                entity.heightTitle = 60
                                entity.heightTopButton = 40
                                entity.heightTopButtonRight = 40
                            case "iPhone XS":
                                entity.heightNavigation = 100
                                entity.heightTitle = 60
                                entity.heightTopButton = 40
                                entity.heightTopButtonRight = 40
                            case "iPhone XS Max":
                                entity.heightNavigation = 100
                                entity.heightTitle = 60
                                entity.heightTopButton = 40
                                entity.heightTopButtonRight = 40
                            case "iPhone XR":
                                entity.heightNavigation = 100
                                entity.heightTitle = 60
                                entity.heightTopButton = 40
                                entity.heightTopButtonRight = 40
                            default:
                                entity.heightNavigation = 80
                                entity.heightTitle = 35
                                entity.heightTopButton = 20
                                entity.heightTopButtonRight = 20
                            }
                            
                            //  check quyền theo tài khoản
                            guard let valueCustomer = dataHome["khachhang"] as? [String: Any] else {return}
                            guard let valueRtype = valueCustomer["rtype"] as? String  else {return}
                            
                            entity.manv = manv
                            entity.isadmin = isadmin?.description
                            entity.mact = mact
                            entity.mapb = mapb
                            entity.mankd = mankd
                            entity.rtype = valueRtype
                            
                            AppDelegate.saveContext()
                            
                            self.performSegue(withIdentifier: "homeSegueId", sender: self)
                        }
                    }
                    else {
                        self.login = 0
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: nil, message: "Sai tên đăng nhập hoặc mật khẩu", preferredStyle: .alert)
                        let openAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                        alert.addAction(openAction)
                        self.present(alert, animated: true , completion: nil)
                    }
                }
            } else {
                self.login = 0
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: nil, message: "Đề nghị kiểm tra lại mã công ty", preferredStyle: .alert)
                let openAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(openAction)
                self.present(alert, animated: true , completion: nil)
            }
        }
    }
    
    func requestCompany() {
        
        let url = URL(string: "https://crm.azmax.vn/services/api.ashx")!
        let param: Parameters = ["device":uuid, "code": companyCodeTextField.text ?? ""]
        print(param)
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success( _):
                if let valueString =  response.result.value as? [String: Any]  {
                    //                    LogFile.write(companyCode: self.companyCodeTextField.text, host: url.description, request: param.description, response: valueString.description, folder: "LogFile_AZCRM")
                    if let msg = valueString["msg"] as? String {
                        if msg == "ok" {
                            
                            UserDefaults.standard.set(self.companyCodeTextField.text, forKey: "companyCode")
                            
                            self.nextCompanyButton.isHidden = true
                            self.dangnhapBt.isHidden = false
                            self.companyButton.isHidden = false
                            self.companyButton1.isHidden = false
                            
                            self.viewLogin.fadeIn()
                            self.viewContact.fadeIn()
                            self.viewCompany.fadeOut()
                            
                            let entity = CompanyCode(context: AppDelegate.context)
                            
                            let data = valueString["data"] as? String
                            let seckey = valueString["seckey"] as? String
                            
                            entity.data = data
                            entity.seckey = seckey
                            
                            AppDelegate.saveContext()
                            
                            if UserDefaults.standard.string(forKey: "userName") != nil {
                                self.dismissKeyboard()
                            } else {
                                self.taikhoanTf.becomeFirstResponder()
                            }
                        } else {
                            let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
                            alert.addAction(title: "Cancel",color:.red)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            case .failure( _):
                break
            }
        }
    }
    
    func requestCompanyCodeLogin() {
        let url = URL(string: "https://crm.azmax.vn/services/api.ashx")!
        let param: Parameters = ["device":uuid, "code": companyCodeTextField.text ?? ""]
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success( _):
                if let valueString =  response.result.value as? [String: Any]  {
                    //                    LogFile.write(companyCode: self.companyCodeTextField.text, host: url.description, request: param.description, response: valueString.description, folder: "LogFile_AZCRM")
                    if let msg = valueString["msg"] as? String {
                        if msg == "ok" {
                            
                            let entity = CompanyCode(context: AppDelegate.context)
                            
                            let data = valueString["data"] as? String
                            let seckey = valueString["seckey"] as? String
                            
                            entity.data = data
                            entity.seckey = seckey
                            
                            AppDelegate.saveContext()
                            self.saveDataContentApi()
                        } else {
                            let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
                            alert.addAction(title: "Cancel",color:.red)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            case .failure( _):
                break
            }
        }
    }
}

