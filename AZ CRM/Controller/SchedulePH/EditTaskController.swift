//
//  EditTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift

protocol EditTaskControllerDelegate: class {
    func reloadEdit()
}

class EditTaskController: BaseViewController {
    
    var macv: Int?
    var ngaybd: String?
    var ngaykt: String?
    
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var tencvTextField: UITextField!
    @IBOutlet weak var loaicvLabel: UILabel!
    @IBOutlet weak var mamdLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var mandLabel: UITextField!
    @IBOutlet weak var buttonTrainsion: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var makh: Int?
    var malcv: Int?
    var matt: Int?
    var mamd: Int?
    var myProduct = [[String: Any]]()
    
    weak var delegate: EditTaskControllerDelegate?
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
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
        
        
        buttonTrainsion.cornerRadius = 20
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         requestDataInfoTask()
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editTaskButton(_ sender: UIButton) {
        SVProgressHUD.show()
        if makhLabel.text != " ", ngaybdLabel.text != " ", ngayktLabel.text != " ", loaicvLabel.text != " ", mattLabel.text != " ", mamdLabel.text != " ", tencvTextField.text != "" {
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                     if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    let param: Parameters = ["method":"taskaddorupdate","themmoi":"false","manv":entity.last!.manv!,"makh":makh!,"ngaybd":ngaybdLabel.text!,"macv":macv!, "ngaykt":ngayktLabel.text!, "malcv":malcv!, "matt":matt!, "mamd":mamd!, "diengiai":mandLabel.text ?? "", "tencv":tencvTextField.text!, "nhanviens":myProduct, "seckey":urlRegister.last!.seckey!]
                    print(param)
                    editTask(param: param)
                }
                }
            } catch let error {
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
            }
            
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditListStaffController {
            vc.macv = macv
            vc.makh = makh
            vc.malcv = malcv
            vc.matt = matt
            vc.mamd = mamd
            vc.ngaykt = ngayktLabel.text
            vc.ngaybd = ngaybdLabel.text
            vc.diengiai = mandLabel.text
            vc.tencv = tencvTextField.text
        }
    }
    
    @IBAction func makhAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customers) { [unowned self] (info) in
            self.makhLabel.text = info?.customer[1] ?? ""
            self.makh = Int(info!.customer[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ngaybdAlertButton(_ sender: UIButton) {
      
        let alert = UIAlertController(title: "Ngày bắt đầu", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaybdLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaybdLabel.text = self.ngaybd ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func ngayktAlertButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Ngày kết thúc", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngayktLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngayktLabel.text = self.ngaykt ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func malcvAlertButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .tasktypes) { [unowned self] (info) in
            self.loaicvLabel.text = info?.tasktypes[1]
            self.malcv = Int(info!.tasktypes[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mamdAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .taskprios) { [unowned self] (info) in
            self.mamdLabel.text = info?.taskprios[1] ?? ""
            self.mamd = Int(info!.taskprios[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mattAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .taskstatus) { [unowned self] (info) in
            self.mattLabel.text = info?.taskstatus[1]
            self.matt = Int(info!.taskstatus[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editStaffButton(_ sender: UIButton) {
        if makhLabel.text != " ", ngaybdLabel.text != " ", ngayktLabel.text != " ", loaicvLabel.text != " ", mattLabel.text != " ", mamdLabel.text != " ", tencvTextField.text != "" {
            performSegue(withIdentifier: "listStaff", sender: self)
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension EditTaskController {
    func requestDataInfoTask() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                self.myProduct = []
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                
                InfoTaskRequest.getInfoStaffTask(parameter: param) { (infoStaffTask) in
                    for vlaueSp in infoStaffTask {
                        let dictionary = [
                            "manv": vlaueSp.manvInt,
                            "mavt": vlaueSp.mavtInt,
                            "diengiai": vlaueSp.diengiai
                            ] as [String : Any]
                        self.myProduct.append(dictionary)
                    }
                }
                
                InfoTaskRequest.getInfoTask(parameter: param) { [unowned self ] (infoTask) in
                    
                    for value in infoTask {
                        self.tencvTextField.text = value.tencv
                        self.ngaybdLabel.text = value.ngaybd
                        self.ngayktLabel.text = value.ngaykt
                        self.mandLabel.text = value.noidung
                        self.makh = value.makh
                        self.malcv = value.maloai
                        self.matt = value.matt
                        self.mamd = value.mamd
                        self.ngaybd = value.ngaybd
                        self.ngaykt = value.ngaykt
                        
                        // get id matt add string label
                        if value.matt != 0 {
                            let paramMatt: Parameters = ["method": "taskstatus","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let matt = valueMalt["matt"] as? Int
                                                let tentt = valueMalt["tentt"] as? String
                                                
                                                if value.matt == matt {
                                                    self.mattLabel.text = tentt
                                                }
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            })
                        }
                        //End
                        
                        // get id mamd add string label
                        if value.mamd != 0 {
                            let paramMatt: Parameters = ["method": "taskprios","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let mamd = valueMalt["mamd"] as? Int
                                                let tenmd = valueMalt["tenmd"] as? String
                                                
                                                if value.mamd == mamd {
                                                    self.mamdLabel.text = tenmd
                                                }
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            })
                        }
                        //End
                        
                        // get id maloai add string label
                        if value.maloai != 0 {
                            let paramMatt: Parameters = ["method": "tasktypes","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let malcv = valueMalt["malcv"] as? Int
                                                let tenloaicv = valueMalt["tenloaicv"] as? String
                                                
                                                if value.maloai == malcv {
                                                    self.loaicvLabel.text = tenloaicv
                                                }
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            })
                        }
                        //End
                        
                        // get id makh add string Label
                        if value.makh != 0 {
                            let paramMakh: Parameters = ["method": "customer", "makh": value.makh,"seckey": urlRegister.last!.seckey!]
                            RequestInfoCustomer.getInforCustomer(parameter: paramMakh) { (inforMakh) in
                                for value in inforMakh {
                                    self.makhLabel.text = value.userName
                                }
                            }
                        }
                        //End
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func editTask(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                  
                                    SVProgressHUD.showSuccess(withStatus: "Thành công")
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.delegate?.reloadEdit()
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                } else {
                                    SVProgressHUD.dismiss()
                                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
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
