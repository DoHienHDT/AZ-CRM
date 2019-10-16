//
//  AddProductController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

protocol AddProductControllerDelegate: class {
    func senData(productLabel: String, dvtLabel: String, soluongTextField: String, dongiaTextField: String , thanhtienLabel: String , tyleCkTextField: String, tienCKTextField: String, vatTextField: String, tienVatTextField: String, tongTienTextField: String, masp: Int, madvt: Int, ngaydh: String,diengiai:String)
}

class AddProductController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dvtLabel: UILabel!
    @IBOutlet weak var soluongTextField: UITextField!
    @IBOutlet weak var dongiaTextField: UITextField!
    @IBOutlet weak var thanhtienLabel: UILabel!
    @IBOutlet weak var tyleCkTextField: UITextField!
    @IBOutlet weak var vatTextField: UITextField!
    @IBOutlet weak var ngaydhLabel: UILabel!
    @IBOutlet weak var tienVatLabel: UILabel!
    @IBOutlet weak var tongtienLabel: UILabel!
    @IBOutlet weak var tienCKTextField: UITextField!
    @IBOutlet weak var diengiaiTextField: UITextField!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var heightViewDG: NSLayoutConstraint!
    @IBOutlet weak var viewDG: UIView!
    @IBOutlet weak var DGLabel: UILabel!
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    var masp: Int?
    var madvt: Int?
    var heightView: CGFloat?
    var delegate: AddProductControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if heightView == 0 {
            heightView = 0
            heightViewDG.constant = heightView!
            viewDG.isHidden = true
            DGLabel.isHidden = true
            diengiaiTextField.isHidden = true
        } else {
            heightView = 70
            heightViewDG.constant = heightView!
            viewDG.isHidden = false
            DGLabel.isHidden = false
            diengiaiTextField.isHidden = false
        }
        
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
        
        
        navigationView.dropShadow()
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let dateOfBirth = dateFormat.string(from: date)
        ngaydhLabel.text = dateOfBirth
        soluongTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
        dongiaTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
        tyleCkTextField.addTarget(self, action: #selector(tienCK(_:)), for: .editingChanged)
        vatTextField.addTarget(self, action: #selector(tienVAT(_:)), for: .editingChanged)
        tienCKTextField.addTarget(self, action: #selector(tyleCK(_:)), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmisTextField))
        view.addGestureRecognizer(tap)
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
        tyleCkTextField.delegate = self
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ngaydhAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngaydhLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày đặt hàng", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaydhLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaydhLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func addProductButton(_ sender: Any) {
        
                if productLabel.text != " ", dvtLabel.text != "", soluongTextField.text != "", dongiaTextField.text != "", thanhtienLabel.text != "", tongtienLabel.text != "" {
                    
                    if tyleCkTextField.text == "", vatTextField.text == "" {
                        delegate?.senData(productLabel: productLabel.text!, dvtLabel: dvtLabel.text!, soluongTextField: soluongTextField.text!, dongiaTextField: dongiaTextField.text!, thanhtienLabel: thanhtienLabel.text!, tyleCkTextField: "0", tienCKTextField: "0", vatTextField: "0", tienVatTextField: "0", tongTienTextField: tongtienLabel.text ?? "0", masp: masp!, madvt: madvt!, ngaydh: ngaydhLabel.text ?? "", diengiai: diengiaiTextField.text ?? "")
                         self.dismiss(animated: true, completion: nil)
                    }
                    
                    if vatTextField.text == "", tyleCkTextField.text != "" {
                        delegate?.senData(productLabel: productLabel.text!, dvtLabel: dvtLabel.text!, soluongTextField: soluongTextField.text!, dongiaTextField: dongiaTextField.text!, thanhtienLabel: thanhtienLabel.text!, tyleCkTextField: tyleCkTextField.text ?? "0", tienCKTextField: tienCKTextField.text ?? "", vatTextField: "0", tienVatTextField: "0", tongTienTextField: tongtienLabel.text ?? "0", masp: masp!, madvt: madvt!, ngaydh: ngaydhLabel.text ?? "", diengiai: diengiaiTextField.text ?? "")
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    if vatTextField.text != "", tyleCkTextField.text == "" {
                        delegate?.senData(productLabel: productLabel.text!, dvtLabel: dvtLabel.text!, soluongTextField: soluongTextField.text!, dongiaTextField: dongiaTextField.text!, thanhtienLabel: thanhtienLabel.text!, tyleCkTextField: "0", tienCKTextField: "0", vatTextField: vatTextField.text ?? "", tienVatTextField: tienVatLabel.text ?? "", tongTienTextField: tongtienLabel.text ?? "0", masp: masp!, madvt: madvt!, ngaydh: ngaydhLabel.text ?? "", diengiai: diengiaiTextField.text ?? "")
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    if vatTextField.text != "", vatTextField.text != "" {
                        delegate?.senData(productLabel: productLabel.text!, dvtLabel: dvtLabel.text!, soluongTextField: soluongTextField.text!, dongiaTextField: dongiaTextField.text!, thanhtienLabel: thanhtienLabel.text!, tyleCkTextField: tyleCkTextField.text ?? "0", tienCKTextField: tienCKTextField.text ?? "", vatTextField: vatTextField.text ?? "", tienVatTextField: tienVatLabel.text ?? "", tongTienTextField: tongtienLabel.text ?? "0", masp: masp!, madvt: madvt!, ngaydh: ngaydhLabel.text ?? "", diengiai: diengiaiTextField.text ?? "")
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Yêu cầu nhập đủ thông tin", message: nil, preferredStyle: .alert)
                    let openAction = UIAlertAction(title: "Đã hiểu", style: .cancel, handler: nil)
                    alert.addAction(openAction)
                    self.present(alert, animated: true, completion: nil)
                }
    }
    
    @IBAction func productButton(_ sender: Any) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAlertAZSoft(Api: .products) { (info) in
                    
                    self.productLabel.text = info?.product[0] ?? ""
                    self.masp = Int(info!.product[2])
                    
                    let param: Parameters = ["method": "productprice","masp":self.masp!,"seckey": urlRegister.last!.seckey!]
//                    print(param)
                    Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                        switch response.result {
                        case .success( _):
                            if let valueString = response.result.value as? [String: Any] {
                                if let valueCode = valueString["data"] as? [String: Any] {
                                    let giaban = valueCode["giaban"] as? Int
                                    let madvtSp = valueCode["madvt"] as? Int
                                    self.madvt = madvtSp
                                    let intSl = Int(self.soluongTextField.text ?? "") ?? 0
                                    let valueDongia = giaban ?? 0 * intSl
                                    self.dongiaTextField.text = valueDongia.description
                                    self.thanhtienLabel.text = valueDongia.description
                                    self.tongtienLabel.text = valueDongia.description
                                    
                                    // get text dvt
                                    let paramDvt: Parameters = ["method": "units","seckey": urlRegister.last!.seckey!]
                                    Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramDvt, encoding: JSONEncoding.default).responseJSON { (response) in
                                        switch response.result {
                                        case .success( _):
                                            if let valueString = response.result.value as? [String: Any] {
                                                if let valueCodeDvt = valueString["data"] as? [[String: Any]] {
                                                    for valueMadvt in valueCodeDvt {
                                                        let madvt = valueMadvt["madvt"] as? Int
                                                        let tendvt = valueMadvt["tendvt"] as? String
                                                        if madvtSp == madvt {
                                                            self.dvtLabel.text = tendvt
                                                        }
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
                alert.view.addConstraint(heightAlert)
                alert.addAction(title: "Cancel", style: .cancel)
                present(alert, animated: true, completion: nil)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func dvtButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .dvtProducts) { (info) in
            self.dvtLabel.text = info?.dvtProduct?[1] ?? ""
            self.madvt = Int(info!.dvtProduct?[0] ?? "")
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dissmisTextField() {
        view.endEditing(true)
    }
    
    @objc func textFieldChange(_ textField: UITextField) {
        let formatNumber = NumberFormatter()
        formatNumber.numberStyle = .decimal
        
//        let convertInt = Double(dongiaTextField.text ?? "") ?? 0.0
        
        let dongiadecimal = Int(dongiaTextField.text ?? "") ?? 0
        let soluongdecimal = Int(soluongTextField.text ?? "") ?? 0
        print(dongiadecimal)
        print(soluongdecimal)
        
        let thanhtien = dongiadecimal * soluongdecimal
        
        let formatString = formatNumber.string(from: NSNumber(value: thanhtien))
        self.thanhtienLabel.text = formatString
        self.tongtienLabel.text = formatString
        
    }
    
    @objc func tienCK(_ textField: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let tyleCKDecimal = Double(tyleCkTextField.text ?? "") ?? 0
        
        if let number = formatter.number(from: thanhtienLabel.text ?? "") {
            let amount = number.decimalValue
            let amountString = Double(amount.description) ?? 0
            
            let tienCK = (tyleCKDecimal / 100) * amountString
            tienCKTextField.text = tienCK.description
            
            let vatTong = Double(vatTextField.text ?? "") ?? 0
            let vat1 = (amountString - tienCK) * (vatTong / 100)
            let tong1 = (amountString - tienCK) + vat1
            
            tongtienLabel.text = tong1.description
            tienVatLabel.text = vat1.description
    
        }
    }
    
    @objc func tyleCK(_ textField: UITextField) {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        
        if let number = formatter.number(from: thanhtienLabel.text ?? ""), let number1 = formatter.number(from: tienCKTextField.text ?? "") {
            
            let amount = number.decimalValue
            let amountString = Double(amount.description) ?? 0
            let amount1 = number1.decimalValue
            let amountString1 = Double(amount1.description) ?? 0
 
            let tyleCK = (amountString1 * 100) / amountString
        
            let formatString = formatter.string(from: NSNumber(value: tyleCK))
           
//            print(tyleCkTextField.count)
            print(number)
            tyleCkTextField.text = formatString
        }
    }
    
    @objc func tienVAT(_ textField: UITextField) {

        guard let textFieldText = vatTextField.text else {
                return
        }
        
        if textFieldText.count >= 3 {
            vatTextField.text = "100"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
 
        let vatTong = Double(vatTextField.text ?? "") ?? 0
        let tienvatTong = Double(tienVatLabel.text ?? "") ?? 0
        if let number = formatter.number(from: thanhtienLabel.text ?? ""), let number2 = formatter.number(from: tienCKTextField.text ?? ""){
            let amount = number.decimalValue
            let amount1 = number2.decimalValue
       
            let amountString = Double(amount.description) ?? 0
            let amountString1 = Double(amount1.description) ?? 0
  
                let vat1 = (amountString - amountString1) * (vatTong / 100)
                let tong1 = (amountString - amountString1) + vat1
            
            print("--- vattien \(vatTong)")
            print("--- thanhtien \(amountString)")
            print("--- tienck \(amountString1)")
            print("--- tienvat \(tienvatTong)")
            
                tienVatLabel.text = vat1.description
                tongtienLabel.text = tong1.description
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = tyleCkTextField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if count > 2 {
            tyleCkTextField.text = "100"
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            let tyleCKDecimal = Double(tyleCkTextField.text ?? "") ?? 0
            
            if let number = formatter.number(from: thanhtienLabel.text ?? "") {
                let amount = number.decimalValue
                let amountString = Double(amount.description) ?? 0
    
                let tienCK = (tyleCKDecimal / 100) * amountString
                tienCKTextField.text = tienCK.description
                
                let vatTong = Double(vatTextField.text ?? "") ?? 0
                let vat1 = (amountString - tienCK) * (vatTong / 100)
                let tong1 = (amountString - tienCK) + vat1
        
                tongtienLabel.text = tong1.description
                tienVatLabel.text = vat1.description
            }
        }
        return count < 3
    }
}
