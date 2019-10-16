//
//  EditProductOpportController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift

class EditProductOpportController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dvtLabel: UILabel!
    @IBOutlet weak var soluongTextField: UITextField!
    @IBOutlet weak var dongiaTextField: UITextField!
    @IBOutlet weak var thanhtienLabel: UILabel!
    @IBOutlet weak var tyleCkTextField: UITextField!
    @IBOutlet weak var tienCKTextField: UITextField!
    @IBOutlet weak var vatTextField: UITextField!
    @IBOutlet weak var tienVatLabel: UILabel!
    @IBOutlet weak var tongTienLabel: UILabel!
    @IBOutlet weak var ngaydhLabel: UILabel!
    @IBOutlet weak var diengiaiTextField: UITextField!
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var mancOpport: Int!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    var ngaydh: String?
    var id: Int?
    var masp: Int?
    var madvt:Int?
    var makh: Int?
    var matt: Int?
    var giatri: String?
    var tiemnang: String?
    var myArray = [[String: Any]]()
    var diengiaiEdit: String?
    var manvhts = [Int]()
    var maso: String?
    
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
        
        myArray = []
        apiOport()
    
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ngaydhAlertButton(_ sender: UIButton) {
        
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
            self.ngaydhLabel.text = self.ngaydh ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func maspAlertButton(_ sender: UIButton) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAlertAZSoft(Api: .products) { (info) in
                    
                    self.productLabel.text = info?.product[0] ?? ""
                    self.masp = Int(info!.product[2])
                    
                    let param: Parameters = ["method": "productprice","masp":self.masp!,"seckey": urlRegister.last!.seckey!]
                    
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
                                    self.tongTienLabel.text = valueDongia.description
                                    
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
                
                let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
                alert.view.addConstraint(heightAlert)
                alert.addAction(title: "Cancel", style: .cancel)
                present(alert, animated: true, completion: nil)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func madvtAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .dvtProducts) { (info) in
            self.dvtLabel.text = info?.dvtProduct?[1] ?? ""
            self.madvt = Int(info!.dvtProduct?[0] ?? "")
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editProductButton(_ sender: UIButton) {
        
        if ngaydhLabel.text != "", soluongTextField.text != "", dongiaTextField.text != "", thanhtienLabel.text != "", tongTienLabel.text != "" {
            
            if tyleCkTextField.text == "", vatTextField.text == "" {
                let dictionary = [
                    "id":id!,
                    "ngaydh": ngaydhLabel.text!,
                    "masp": masp!,
                    "madvt": madvt!,
                    "soluong": soluongTextField.text!,
                    "dongia": dongiaTextField.text!,
                    "thanhtien": thanhtienLabel.text!,
                    "sotien": tongTienLabel.text!,
                    "thuegtgt": 0,
                    "tiengtgt": 0,
                    "tyleck": 0,
                    "tienck": 0,
                    "diengiai": diengiaiTextField.text ?? ""
                    ] as [String : Any]
                myArray.append(dictionary)
            }
            if vatTextField.text == "", tyleCkTextField.text != "" {
                let dictionary = [
                    "id":id!,
                    "ngaydh": ngaydhLabel.text!,
                    "masp": masp!,
                    "madvt": madvt!,
                    "soluong": soluongTextField.text!,
                    "dongia": dongiaTextField.text!,
                    "thanhtien": thanhtienLabel.text!,
                    "sotien": tongTienLabel.text!,
                    "thuegtgt": 0,
                    "tiengtgt": 0,
                    "tyleck": tyleCkTextField.text!,
                    "tienck": tienCKTextField.text!,
                    "diengiai": diengiaiTextField.text ?? ""
                    ] as [String : Any]
                myArray.append(dictionary)
            }
            if vatTextField.text != "", tyleCkTextField.text == "" {
                let dictionary = [
                    "id":id!,
                    "ngaydh": ngaydhLabel.text!,
                    "masp": masp!,
                    "madvt": madvt!,
                    "soluong": soluongTextField.text!,
                    "dongia": dongiaTextField.text!,
                    "thanhtien": thanhtienLabel.text!,
                    "sotien": tongTienLabel.text!,
                    "thuegtgt": vatTextField.text!,
                    "tiengtgt": tienVatLabel.text!,
                    "tyleck": 0,
                    "tienck": 0,
                    "diengiai": diengiaiTextField.text ?? ""
                    ] as [String : Any]
                myArray.append(dictionary)
            }
            if vatTextField.text != "", vatTextField.text != "" {
                let dictionary = [
                    "id":id!,
                    "ngaydh": ngaydhLabel.text!,
                    "masp": masp!,
                    "madvt": madvt!,
                    "soluong": soluongTextField.text!,
                    "dongia": dongiaTextField.text!,
                    "thanhtien": thanhtienLabel.text!,
                    "sotien": tongTienLabel.text!,
                    "thuegtgt": vatTextField.text!,
                    "tiengtgt": tienVatLabel.text!,
                    "tyleck": tyleCkTextField.text!,
                    "tienck": tienCKTextField.text!,
                    "diengiai": diengiaiTextField.text ?? ""
                    ] as [String : Any]
                myArray.append(dictionary)
            }
            
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        let param: Parameters = ["method": "opportunityaddorupdate", "themmoi": "false", "manc":mancOpport!,"maso":maso ?? "", "makh":makh!,"matt":matt!,"manv": entity.last!.manv!,"tiemnang":tiemnang!,"giatri":giatri ?? "","manvhts":manvhts,"sanphams": myArray,"diengiai":diengiaiEdit ?? "","seckey": urlRegister.last!.seckey!]
                        print(param)
                        editOpport(param: param)
                    }
                }
            }  catch let error {
                print(error.localizedDescription)
            }
        }  else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension EditProductOpportController {
    
    func editOpport(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { [unowned self] (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            print(param)
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
    
    func apiOport() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunity","manc": mancOpport!,"seckey": urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareProductOpport(parameter: param) { [unowned self] (product) in
                    for valueProduct in product {
                        if valueProduct.id == self.id {
                            self.masp = valueProduct.maspSP
                            self.madvt = valueProduct.madvtSP
                            self.productLabel.text = valueProduct.tenspSP
                            self.dvtLabel.text = valueProduct.tendvtSP
                            self.soluongTextField.text = valueProduct.soluongSP?.description
                            self.dongiaTextField.text = valueProduct.dongiaSP?.description
                            self.thanhtienLabel.text = valueProduct.thanhtienSP?.description
                            self.tyleCkTextField.text = valueProduct.tyleckSP?.description
                            self.tienCKTextField.text = valueProduct.tienckSP?.description
                            self.vatTextField.text = valueProduct.thuegtgtSP?.description
                            self.tienVatLabel.text = valueProduct.tiengtgtSP?.description
                            self.tongTienLabel.text = valueProduct.sotienSP?.description
                            self.diengiaiTextField.text = valueProduct.diengiaiSP
                            self.ngaydhLabel.text = valueProduct.ngaydhSP
                            self.ngaydh = valueProduct.ngaydhSP
                        } else {
                            
                            let dictionary = [
                                "ngaydh": valueProduct.ngaydhSP!,
                                "masp": valueProduct.maspSP!,
                                "madvt": valueProduct.madvtSP!,
                                "soluong": valueProduct.soluongSP!,
                                "dongia": valueProduct.dongiaSP!,
                                "thanhtien": valueProduct.thanhtienSP ?? "",
                                "sotien": valueProduct.sotienSP!,
                                "thuegtgt": valueProduct.thuegtgtSP!,
                                "tiengtgt": valueProduct.tiengtgtSP!,
                                "tyleck": valueProduct.tyleckSP!,
                                "tienck": valueProduct.tienckSP!,
                                "diengiai": valueProduct.diengiaiSP ?? ""
                                ] as [String : Any]
                            
                            self.myArray.append(dictionary)
                        }
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
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
    @objc func textFieldChange(_ textField: UITextField) {
        let formatNumber = NumberFormatter()
        formatNumber.numberStyle = .decimal
        
        let dongiadecimal = Int(dongiaTextField.text ?? "") ?? 0
        let soluongdecimal = Int(soluongTextField.text ?? "") ?? 0
        
        let thanhtien = dongiadecimal * soluongdecimal
        
        let formatString = formatNumber.string(from: NSNumber(value: thanhtien))
        self.thanhtienLabel.text = formatString
        self.tongTienLabel.text = formatString
        
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
            
            tongTienLabel.text = tong1.description
            tienVatLabel.text = vat1.description
            if tyleCkTextField.text == "" {
                tienCKTextField.text = ""
            }
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
            
            print(number1)
            print(number)
            tyleCkTextField.text = formatString
            
            
        }
    }
    
    @objc func tienVAT(_ textField: UITextField) {
        
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
            tongTienLabel.text = tong1.description
            
            if vatTextField.text == "" {
                tienVatLabel.text = ""
            }
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
                
                tongTienLabel.text = tong1.description
                tienVatLabel.text = vat1.description
            }
        }
        return count < 3
    }
}

