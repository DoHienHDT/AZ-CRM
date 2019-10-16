//
//  EditOpportController.swift
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

class EditOpportController: BaseViewController {
    
    @IBOutlet weak var masoLabel: UITextField!
    @IBOutlet weak var ngaytaoLabel: UILabel!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var tiemnangLabel: UILabel!
    @IBOutlet weak var giatriTextField: UITextField!
    @IBOutlet weak var nvhtLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buttonTrainsion: UIButton!
    @IBOutlet weak var diengiaiTextField: UITextField!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    
    var mancOpport: Int?
    var makhString: String?
    var makh: Int?
    var matt: Int?
    var valueString = [String]()
    var simpleSelectedArray = [String]()
    var manvhts: [Int] = []
    var manvhtsString: [String] = []
    
    var manvString = [String]()
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makhLabel.text = makhString ?? ""
        
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
        
        buttonTrainsion.cornerRadius = 25
        apiOportProcess()
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButton(_ sender: Any) {
        SVProgressHUD.show()
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let paramProduct: Parameters = ["method": "opportunity","manc": mancOpport!,"seckey": urlRegister.last!.seckey!]
                var paramOpport: Parameters = [:]
                var myArray = [[String: Any]]()
                if masoLabel.text != "", makhLabel.text != "", statusLabel.text != "" {
                    do {
                        if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                            
                            RequestTakeCareOpport.getTakeCareProductOpport(parameter: paramProduct) { [unowned self] (product) in
                                for valueSP in product {
                                    
                                    let dictionary = [
                                        "ngaydh": valueSP.ngaydhSP!,
                                        "masp": valueSP.maspSP!,
                                        "madvt": valueSP.madvtSP!,
                                        "soluong": valueSP.soluongSP!,
                                        "dongia": valueSP.dongiaSP!,
                                        "thanhtien": valueSP.thanhtienSP!,
                                        "sotien": valueSP.sotienSP!,
                                        "thuegtgt": valueSP.thuegtgtSP!,
                                        "tiengtgt": valueSP.tiengtgtSP!,
                                        "tyleck": valueSP.tyleckSP!,
                                        "tienck": valueSP.tienckSP!,
                                        "diengiai": valueSP.diengiaiSP ?? ""
                                        ] as [String : Any]
                                    myArray.append(dictionary)
                                }
                                
                                paramOpport  = ["method":"opportunityaddorupdate", "themmoi":"false", "maso": self.masoLabel.text!,"manc":self.mancOpport!, "makh": self.makh!, "matt": self.matt!, "manv": entity.last!.manv!, "tiemnang":self.tiemnangLabel.text!, "manvhts": self.manvhts,"sanphams":myArray,"giatri":self.giatriTextField.text ?? "","diengiai":self.diengiaiTextField.text ?? "", "seckey": urlRegister.last!.seckey!]
                                print(paramOpport)
                                self.editOpport(param: paramOpport)
                            }
                        }
                    }  catch let error {
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                }
            }
        } catch let error {
            SVProgressHUD.dismiss()
            print(error.localizedDescription)
        }
    }
    
    @IBAction func makhAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customers) { (info) in
            self.makhLabel.text = info?.customer[1] ?? ""
            self.makh = Int(info!.customer[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nvhtAlertButton(_ sender: Any) {
        self.showAsAlertController(style: .actionSheet, title: "Select Player", action: "Done", height: nil)
    }
    
    @IBAction func statusAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .opportunitystatus) { (info) in
            self.statusLabel.text = info?.opportunitystatus[1] ?? ""
            self.tiemnangLabel.text = info!.opportunitystatus[0]
            self.matt = Int(info!.opportunitystatus[2])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func editProductButton(_ sender: Any) {
        
        if let storyboad = self.storyboard {
            if let vc = storyboad.instantiateViewController(withIdentifier: "ListEditProductOpportController") as? ListEditProductOpportController {
                vc.makh = makh
                vc.matt = matt
                vc.giatri = giatriTextField.text
                vc.tiemnang = tiemnangLabel.text
                vc.mancOpport = mancOpport
                vc.manvhts = manvhts
                vc.maso = masoLabel.text
                vc.diengiaiEdit = diengiaiTextField.text
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension EditOpportController {
    
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
            print(items)
            self?.nvhtLabel.text = items.joined(separator: ", ")
            self?.simpleSelectedArray = items
            
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
    
    func apiOportProcess() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunity","manc":mancOpport!,"seckey": urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareOport(parameter: param) { [unowned self] (takeCare) in
                    for valueOpport in takeCare {
                        self.ngaytaoLabel.text = valueOpport.ngaytao
                        self.masoLabel.text = valueOpport.maso
                        self.giatriTextField.text = valueOpport.giatri.description
                        self.manvhtsString = valueOpport.manvhts ?? []
                        self.matt = valueOpport.matt
                        self.tiemnangLabel.text = valueOpport.tiemnang.description
                        let inAraay = self.manvhtsString.map { Int($0)!}
                        self.manvhts = inAraay
                        self.diengiaiTextField.text = valueOpport.diengiai
                        
                        var arrayString = [String]()
                        print(inAraay)
                        
                        if inAraay.count != 0 {
                            for value in inAraay {
                                let param: Parameters = ["method": "staffs","seckey": urlRegister.last!.seckey!]
                                AlertRequestApi.getInfo(param: param, type: .staff) { [unowned self] (info) in
                                    for valueId in info {
                                        if value == Int(valueId.staff[0]) {
                                            arrayString.append(valueId.staff[1])
                                            self.nvhtLabel.text = arrayString.joined(separator: ", ")
                                            self.simpleSelectedArray.append(valueId.staff[1])
                                        }
                                    }
                                }
                            }
                        }
                        
                        // so sánh để lấy được text status
                        let paramStatus: Parameters = ["method": "opportunitystatus","seckey": urlRegister.last!.seckey!]
                        RequestGroups.getOpportStatus(parameters: paramStatus) { [unowned self] (status) in
                            
                            for valueStatus in status {
                                
                                if Int(valueStatus.status[1]) == valueOpport.matt{
                                    self.statusLabel.text = valueStatus.status[2]
                                }
                            }
                        }
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func editOpport(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { [unowned self] (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            print("param edit opport \n \(param)")
                            if let message = valueString["msg"] as? String {
                                
                                if message == "ok" {
                                    
                                    SVProgressHUD.showSuccess(withStatus: "Thành công")
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

