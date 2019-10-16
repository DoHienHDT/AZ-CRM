//
//  EditContactController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift
class EditContactController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var cvuTextField: UITextField!
    @IBOutlet weak var hotenTextField: UITextField!
    @IBOutlet weak var didongTextField: UITextField!
    @IBOutlet weak var didongkTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var malhTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doituongLabel: UILabel!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    
    var malh: Int?
    var makh: Int?
    var makhString: String?
    var ngaysinh: String?
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        malhTextField.becomeFirstResponder()
        doituongLabel.text = makhString ?? ""
        SVProgressHUD.show()
        
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                 if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    
                    heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                    topButton.constant = CGFloat(entity.last!.heightTopButton)
                    heightTitle.constant = CGFloat(entity.last!.heightTitle)
                    topButtonRight.constant = CGFloat(entity.last!.heightTopButtonRight)
                
                let param: Parameters = ["method": "contact","malh":"\(malh!)","seckey": urlRegister.last!.seckey!]
                
                RequestInfoContact.getInfoContact(parameter: param) { [unowned self] (infor) in
                    
                    for value in infor {
                        self.malhTextField.text = value.malh
                        self.cvuTextField.text = value.position
                        self.hotenTextField.text = value.name
                        self.didongTextField.text = value.tel
                        self.didongkTextField.text = value.phone
                        self.emailTextField.text = value.mail
                        self.noteTextField.text = value.note
                        self.dateLabel.text = value.ngaysinh
                        self.ngaysinh = value.ngaysinh
                    }
                    
                    SVProgressHUD.dismiss()
                  }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmisTextField))
        view.addGestureRecognizer(tap)
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dateAlertButton(_ sender: Any) {
        
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
            self.dateLabel.text = self.ngaysinh ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func makhAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customers) { [unowned self] (info) in
            self.doituongLabel.text = info?.customer[1] ?? ""
            self.makh = Int(info!.customer[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        SVProgressHUD.show()
        //Lấy dữ liệu từ coreData
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "contactaddorupdate","themmoi":false,"maso": malhTextField.text ?? "","malh":"\(malh!)", "manv": entity.last!.manv!, "hoten": "\(hotenTextField.text ?? "")", "didong": "\(didongTextField.text ?? "")", "didongkhac": "\(didongkTextField.text ?? "")", "email": "\(emailTextField.text ?? "")", "chucvu": "\(cvuTextField.text ?? "")","makh":makh!, "ghichu":"\(noteTextField.text ?? "")","ngaysinh":dateLabel.text ?? "","seckey": urlRegister.last!.seckey!]
                print(param)
                updateEditApi(param: param)
            }
          }
        } catch  {
            SVProgressHUD.dismiss()
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateEditApi(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(_):
                        if let valueString = response.result.value as? [String: Any] {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                    
                                    SVProgressHUD.showSuccess(withStatus: "Thành công")
                                    SVProgressHUD.dismiss(withDelay: 2, completion: {
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                } else {
                                    SVProgressHUD.dismiss()
                                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                    let openAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                    alert.addAction(openAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    case .failure(_):
                        print("error")
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension EditContactController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.endEditing(true)
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    @objc func dissmisTextField() {
        view.endEditing(true)
    }

}
