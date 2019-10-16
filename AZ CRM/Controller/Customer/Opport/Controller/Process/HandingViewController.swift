//
//  HandingViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import RSSelectionMenu
import IQKeyboardManagerSwift
import SVProgressHUD
class HandingViewController: BaseViewController {
    
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var ngayxlLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var giatriTextField: UITextField!
    @IBOutlet weak var httxLabel: UILabel!
    @IBOutlet weak var manvhtsLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var ngayttLabel: UILabel!
    @IBOutlet weak var thanhtoanLabel: UITextField!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var masoLabel: UILabel!
    
    var simpleSelectedArray = [String]()
    var valueString = [String]()
    var manc: Int?
    var maso: String?
    var matt: Int?
    var mahttx: Int?
    var manv: Int?
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        masoLabel.text = maso ?? ""
        navigationView.dropShadow()
        
        CheckPerform.shared.checkDismis = false
        
        processButton.cornerRadius = 25
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                let filePath = url.appendingPathComponent("ApiStaff")?.path
                
                if let _ = FileManager.default.contents(atPath: filePath!) {
                    let array = NSArray(contentsOfFile: filePath!)
                    for (_,patientObj) in array!.enumerated() {
                        let patientDict = patientObj as! NSDictionary
                        let patient = Patient(id: patientDict.value(forKey: "id") as? Int, ten: patientDict.value(forKey: "ten") as? String)
                        if Int(entity.last!.manv!) == patient.id {
                            self.manv = patient.id!
                            self.manvhtsLabel.text = patient.ten!
                        }
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngayxlLabel.text = todayString
    }
    
    @IBAction func staftButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .staff) { [unowned self] (info) in
            self.manvhtsLabel.text = info?.staff[1]
            self.manv = Int(info!.staff[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CheckPerform.shared.checkDismis == true {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcDetail = segue.destination as? AddSchedulesOpportController {
            vcDetail.manc = manc
            vcDetail.matt = matt
            vcDetail.mahttx = mahttx
            vcDetail.noidung = contentTextField.text
            vcDetail.ngayxl = ngayxlLabel.text
            vcDetail.giatri = giatriTextField.text
            vcDetail.manv = self.manv ?? 0
            vcDetail.ngaytt = ngayttLabel.text
            vcDetail.thanhtoan = thanhtoanLabel.text
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addSuccessButton(_ sender: UIButton) {
        if ngayxlLabel.text != " ", mattLabel.text != " ", httxLabel.text != " "{
            
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        let param: Parameters = ["method":"opportunityprocessadd",
                                                 "manc":manc!,
                                                 "manvn":entity.last!.manv!,
                                                 "manv":manv ?? 0,
                                                 "ngayxl":ngayxlLabel.text!,
                                                 "thanhtoan":thanhtoanLabel.text ?? "",
                                                 "giatri":giatriTextField.text ?? "",
                                                 "ngaytt":ngayttLabel.text ?? "",
                                                 "matt":matt!,
                                                 "mahttx":mahttx!,
                                                 "noidung":contentTextField.text ?? "",
                                                 "seckey":urlRegister.last!.seckey!]
                        addOpportProcess(param: param)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok",color:.red, style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addProcessButton(_ sender: UIButton) {
        if ngayxlLabel.text != " ", mattLabel.text != " ", httxLabel.text != " ",manvhtsLabel.text != " "{
            
            self.performSegue(withIdentifier: "addSchedules", sender: self)
            
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func ngayttAlertButton(_ sender: UIButton) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngayttLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày thanh toán", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngayttLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngayttLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func ngayxlAlertButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Ngày xử lý", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngayxlLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngayxlLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func mattAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .opportunitystatus) { (info) in
            self.mattLabel.text = info?.opportunitystatus[1] ?? ""
            self.matt = Int(info!.opportunitystatus[2])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func mahttxAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .opportunitymeettypes) { (info) in
            self.httxLabel.text = info?.opportunitymeettypes[1] ?? ""
            self.mahttx = Int(info!.opportunitymeettypes[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension HandingViewController {
    func addOpportProcess(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { [unowned self] (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            print("param edit opport \n \(param)")
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

