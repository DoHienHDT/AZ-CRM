//
//  AddOportController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import RSSelectionMenu
import IQKeyboardManagerSwift

class AddOportController: BaseViewController, UITextFieldDelegate, AddProductControllerDelegate{
    
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var masoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var staffSupportLabel: UILabel!
    @IBOutlet weak var pontenialLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var giatriTextField: UITextField!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var buttonTrainsion: UIButton!
    @IBOutlet weak var diengiaiTextField: UITextField!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    
    var product = [DelegateDataProduct]()
    var matt: Int?
    var makh: Int?
    var manvString = [String]()
    var valueString = [String]()
    var simpleSelectedArray = [String]()
    var manvhts: [Int] = []
    
    var myProduct = [[String: Any]]()
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
        tableView.isHidden = true
        heightTableView.constant = 1
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmisTextField))
        view.addGestureRecognizer(tap)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("ApiStaff")?.path
        
        if let _ = FileManager.default.contents(atPath: filePath!) {
            let array = NSArray(contentsOfFile: filePath!)
            for (_,patientObj) in array!.enumerated() {
                let patientDict = patientObj as! NSDictionary
                let patient = Patient(id: patientDict.value(forKey: "id") as? Int, ten: patientDict.value(forKey: "ten") as? String)
                self.manvString.append(patient.ten ?? "")
            }
        }
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCode()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func staffButton(_ sender: Any) {
        self.showAsAlertController(style: .actionSheet, title: "Chọn 1 hoặc nhiều nhân viên hỗ trợ", action: "Done", height: nil)
    }
    
    @IBAction func statusButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .opportunitystatus) { (info) in
            self.statusLabel.text = info?.opportunitystatus[1] ?? ""
            self.pontenialLabel.text = info!.opportunitystatus[0]
            self.matt = Int(info!.opportunitystatus[2])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func customerButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customers) { (info) in
            self.customerLabel.text = info?.customer[1] ?? ""
            self.makh = Int(info!.customer[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func senData(productLabel: String, dvtLabel: String, soluongTextField: String, dongiaTextField: String, thanhtienLabel: String, tyleCkTextField: String, tienCKTextField: String, vatTextField: String, tienVatTextField: String, tongTienTextField: String, masp: Int, madvt: Int, ngaydh: String, diengiai: String) {
        let dataProduct: DelegateDataProduct = DelegateDataProduct(productLabel: productLabel, dvtLabel: dvtLabel, soluongTextField: soluongTextField, dongiaTextField: dongiaTextField, thanhtienLabel: thanhtienLabel, tyleCkTextField: tyleCkTextField, tienCKTextField: tienCKTextField, vatTextField: vatTextField, tienVatTextField: tienVatTextField, tongTienTextField: tongTienTextField, masp: masp, madvt: madvt, ngaydh: ngaydh, diengiai: diengiai)
        tableView.isHidden = false
        heightTableView.constant = 230
        product.append(dataProduct)
        tableView.reloadData()
    }
    
    @IBAction func addProductButton(_ sender: Any) {
        //Lấy dữ liệu từ coreData
        if giatriTextField.text != " ", statusLabel.text != " ", pontenialLabel.text != " ", customerLabel.text != " " {
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        if product.count != 0 {
                            for value in product {
                                let dictionary = [
                                    "ngaydh": value.ngaydh,
                                    "masp": value.masp,
                                    "madvt": value.madvt,
                                    "soluong": value.soluongTextField,
                                    "dongia": value.dongiaTextField,
                                    "thanhtien": value.thanhtienLabel,
                                    "sotien": value.tongTienTextField,
                                    "thuegtgt": value.vatTextField,
                                    "tiengtgt": value.tienVatTextField,
                                    "tyleck": value.tyleCkTextField,
                                    "tienck": value.tienCKTextField,
                                    "diengiai": value.diengiai
                                    ] as [String : Any]
                                self.myProduct.append(dictionary)
                            }
                            
                            let param: Parameters = ["method":"opportunityaddorupdate","themmoi":"true", "maso": masoLabel.text ?? "","manv": entity.last!.manv!, "makh": makh ?? 0,"matt":matt ?? 0, "tiemnang": Int(pontenialLabel.text ?? "")!,"giatri":giatriTextField.text ?? "","manvhts":manvhts,"seckey":urlRegister.last!.seckey!,"diengiai":diengiaiTextField.text ?? "","sanphams": myProduct]
                            
                            addOpport(param: param)
                            
                        } else {
                            let alertVC = UIAlertController(title: "Bạn cần nhập đủ thông tin của cơ hội và sản phẩm", message: nil, preferredStyle: .alert)
                            let openAction = UIAlertAction(title: "ok", style: .cancel) { (_) in
                            }
                            alertVC.addAction(openAction)
                            present(alertVC, animated: true, completion: nil)
                        }
                    }
                }
            } catch  {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            let alertVC = UIAlertController(title: "Bạn cần nhập đủ thông tin của cơ hội và sản phẩm", message: nil, preferredStyle: .alert)
            
            let openAction = UIAlertAction(title: "ok", style: .cancel) { (_) in
                
            }
            alertVC.addAction(openAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addOpportButton(_ sender: Any) {
        if let storyboad = self.storyboard {
            if let detailVc = storyboad.instantiateViewController(withIdentifier: "AddProduct") as? AddProductController {
                detailVc.delegate = self
                detailVc.heightView = 70
                self.present(detailVc, animated: true, completion: nil)
            }
        }
    }
    
}

extension AddOportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sản phẩm"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        
        cell.spLabel.text = product[indexPath.row].productLabel
        cell.soluongLabel.text = String(product[indexPath.row].soluongTextField)
        cell.thanhTienLabel.text = String(product[indexPath.row].thanhtienLabel)
        cell.tienCKLabel.text = String(product[indexPath.row].tienCKTextField)
        cell.tienVatLabel.text = String(product[indexPath.row].tienVatTextField)
        cell.tongTienLabel.text = String(product[indexPath.row].tongTienTextField)
        
        return cell
    }
}

extension AddOportController {
    
    // alert multipe selected nvht api staff
    func showAsAlertController(style: UIAlertController.Style, title: String?, action: String?, height: Double?) {
        let selectionStyle: SelectionStyle = style == .alert ? .single : .multiple
        
        let selectionMenu = RSSelectionMenu(selectionStyle: selectionStyle, dataSource: manvString) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, index, isSelected, selectedItems) in
        }
        
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
            
            // return filtered array based on any condition
            // here let's return array where name starts with specified search text
            
            return self?.manvString.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) }) ?? []
        }
        
        selectionMenu.onDismiss = { [weak self] items in
            self?.manvhts = []
            self?.simpleSelectedArray = items
            self?.staffSupportLabel.text = items.joined(separator: ", ")
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            let filePath = url.appendingPathComponent("ApiStaff")?.path
            
            if let _ = FileManager.default.contents(atPath: filePath!) {
                let array = NSArray(contentsOfFile: filePath!)
                for (_,patientObj) in array!.enumerated() {
                    let patientDict = patientObj as! NSDictionary
                    let patient = Patient(id: patientDict.value(forKey: "id") as? Int, ten: patientDict.value(forKey: "ten") as? String)
                    for valueName in items {
                        if valueName == patient.ten ?? "" {
                            self?.manvhts.append(patient.id!)
                        }
                    }
                }
            }
        }
        
        let menuStyle: PresentationStyle = style == .alert ? .alert(title: title, action: action, height: height) : .actionSheet(title: title, action: action, height: height)
        
        selectionMenu.show(style: menuStyle, from: self)
    }
    
    func requestCode() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunitycode","seckey": urlRegister.last!.seckey!]
                
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        if let valueString = response.result.value as? [String: Any] {
                            let valueCode = valueString["data"] as? String
                            self.masoLabel.text = valueCode
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
    
    func addOpport(param: Parameters) {
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
    
    @objc func dissmisTextField() {
        view.endEditing(true)
    }
    
}

