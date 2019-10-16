//
//  EditSchedulesController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift
import RSSelectionMenu

class EditSchedulesController: BaseViewController {
    
    @IBOutlet weak var tieudeTextField: UITextField!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var manvhtsLabel: UILabel!
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var nhactruocLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var macvLabel: UILabel!
    @IBOutlet weak var ngayNhacLabel: UILabel!
    @IBOutlet weak var mandTextField: UITextField!
    
    var valueString = [String]()
    var simpleSelectedArray = [String]()
    var simpleSelectedArray1 = [String]()
    var manvhts: [Int] = []
    var makh: Int?
    var malh: Int?
    var macv: String?
    
    var manvString = [String]()
    
    let myArray = ["5 phút", "10 phút", "20 phút", "30 phút", "1 giờ", "2 giờ", "3 giờ", "4 giờ", "5 giờ", "6 giờ",
                   "7 giờ", "8 giờ ", "9 giờ", "10 giờ", "11 giờ", "12 giờ", "1 ngày", "2 ngày", "3 ngày","4 ngày", "5 ngày",
                   "6 ngày","1 tuần", "2 tuần", "3 tuần", "4 tuần", "5 tuần", "6 tuần"]
    var timeNT = Date()
    var dateBD = Date()
    var intNT = 5
    var ngaybd: String?
    var ngaykt: String?

    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
                topButton.constant = CGFloat(entity.last!.heightTopButtonRight)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        requestData()
        
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
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func macvAlertButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .tasks) { [unowned self] (info) in
            self.macvLabel.text = info?.tasks[1] ?? ""
            self.macv = info!.tasks[0]
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func capnhatButton(_ sender: UIButton) {
        SVProgressHUD.show()
        if  tieudeTextField.text != "", ngaybdLabel.text != " ", ngayktLabel.text != " ",nhactruocLabel.text != " " {
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                     if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        let param: Parameters = ["method": "schedueaddorupdate", "themmoi": "false","malh":malh!, "manv": entity.last!.manv!, "tieude": tieudeTextField.text!, "diadiem": addressTextField.text ?? "", "ngaybd": ngaybdLabel.text!, "ngaykt": ngayktLabel.text!, "nhactruoc":intNT,"macv":macv ?? "", "makh":makh ?? "", "manvhts": manvhts,"noidung":mandTextField.text ?? "", "seckey":urlRegister.last!.seckey!]
                        print(param)
                        editSchedule(param: param)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func makhAlertButton(_ sender: UIButton) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customers) { [unowned self] (info) in
            self.makhLabel.text = info?.customer[1] ?? ""
            self.makh = Int(info!.customer[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func manvhtsAlertButton(_ sender: UIButton) {
        view.endEditing(true)
         self.showAsAlertController(style: .actionSheet, title: "Select Player", action: "Done", height: nil)
    }
    
    @IBAction func ngaybdAlertButton(_ sender: UIButton) {
        view.endEditing(true)
        let dateAdd = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormat.amSymbol = "AM"
        dateFormat.pmSymbol = "PM"
        let todayString = dateFormat.string(from: dateAdd!)
        self.ngaybdLabel.text = "\(todayString):00"
        
        let alert = UIAlertController(title: "Ngày bắt đầu", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: dateAdd, maximumDate: nil) { (date) in
            self.dateBD = date
            self.timeNT = Calendar.current.date(byAdding: .minute, value: -5, to: self.dateBD)!
            
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaybdLabel.text = "\(dateOfBirth):00"
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaybdLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func nhactrcAlertButton(_ sender: UIButton) {
        view.endEditing(true)
        self.showAsFormsheet()
    }
    
    @IBAction func ngayktAlertButton(_ sender: UIButton) {
        view.endEditing(true)
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormat.amSymbol = "AM"
        dateFormat.pmSymbol = "PM"
        let todayString = dateFormat.string(from: today)
        self.ngayktLabel.text = "\(todayString):00"
        
        let dateAdd = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
        
        let alert = UIAlertController(title: "Ngày kết thúc", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: dateAdd, maximumDate: nil) { (date) in
            
            
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngayktLabel.text = "\(dateOfBirth):00"
            
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngayktLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
}

extension EditSchedulesController {
    
    func showAsFormsheet() {
        
        /// You can also set selection style - while creating menu instance
        
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: myArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // cell customization
            // set tint color
            cell.tintColor = UIColor.orange
        }
        
        // provide - selected items and selection delegate
        
        menu.setSelectedItems(items: simpleSelectedArray1) { [weak self] (name, index, selected, selectedItems) in
            self?.simpleSelectedArray1 = selectedItems
            
            /// do some stuff...

            self?.nhactruocLabel.text = name
            self?.ngayNhacLabel.text = "Nhắc trước"
            switch name {
            case "5 phút":
                self?.intNT = 5
                self?.timeNT = Calendar.current.date(byAdding: .minute, value: -5, to: self!.dateBD)!
                
            case "10 phút":
                self?.intNT = 10
                self?.timeNT = Calendar.current.date(byAdding: .minute, value: -10, to: self!.dateBD)!
                
            case "20 phút":
                self?.intNT = 20
                self?.timeNT = Calendar.current.date(byAdding: .minute, value: -20, to: self!.dateBD)!
                
            case "30 phút":
                self?.intNT = 30
                self?.timeNT = Calendar.current.date(byAdding: .minute, value: -30, to: self!.dateBD)!
                
            case "1 giờ":
                self?.intNT = 60
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -1, to: self!.dateBD)!
                
            case "2 giờ":
                self?.intNT = 120
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -2, to: self!.dateBD)!
                
            case "3 giờ":
                self?.intNT = 180
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -3, to: self!.dateBD)!
                
            case "4 giờ":
                self?.intNT = 240
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -4, to: self!.dateBD)!
                
            case "5 giờ":
                self?.intNT = 300
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -5, to: self!.dateBD)!
                
            case "6 giờ":
                self?.intNT = 360
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -6, to: self!.dateBD)!
                
            case "7 giờ":
                self?.intNT = 420
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -7, to: self!.dateBD)!
                
            case "8 giờ":
                self?.intNT = 480
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -8, to: self!.dateBD)!
                
            case "9 giờ":
                self?.intNT = 540
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -9, to: self!.dateBD)!
                
            case "10 giờ":
                self?.intNT = 600
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -10, to: self!.dateBD)!
                
            case "11 giờ":
                self?.intNT = 660
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -11, to: self!.dateBD)!
                
            case "12 giờ":
                self?.intNT = 720
                self?.timeNT = Calendar.current.date(byAdding: .hour, value: -12, to: self!.dateBD)!
                
            case "1 ngày":
                self?.intNT = 1440
                self?.timeNT = Calendar.current.date(byAdding: .day, value: -1, to: self!.dateBD)!
                
            case "2 ngày":
                self?.intNT = 2880
                self?.timeNT = Calendar.current.date(byAdding: .day, value: -2, to: self!.dateBD)!
                
            case "3 ngày":
                self?.intNT = 4320
                self?.timeNT = Calendar.current.date(byAdding: .day, value: -3, to: self!.dateBD)!
                
            case "4 ngày":
                self?.intNT = 5760
                self?.timeNT = Calendar.current.date(byAdding: .day, value: -4, to: self!.dateBD)!
                
            case "5 ngày":
                self?.intNT = 7200
                self?.timeNT = Calendar.current.date(byAdding: .day, value: -5, to: self!.dateBD)!
                
            case "6 ngày":
                self?.intNT = 8640
                self?.timeNT = Calendar.current.date(byAdding: .day, value: -6, to: self!.dateBD)!
                
            case "1 tuần":
                self?.intNT = 17280
                self?.timeNT = Calendar.current.date(byAdding: .weekday, value: -1, to: self!.dateBD)!
                
            case "2 tuần":
                self?.intNT = 25920
                self?.timeNT = Calendar.current.date(byAdding: .weekday, value: -2, to: self!.dateBD)!
                
            case "3 tuần":
                self?.intNT = 34560
                self?.timeNT = Calendar.current.date(byAdding: .weekday, value: -3, to: self!.dateBD)!
                
            case "4 tuần":
                self?.intNT = 43200
                self?.timeNT = Calendar.current.date(byAdding: .weekday, value: -4, to: self!.dateBD)!
                
            case "5 tuần":
                self?.intNT = 51840
                self?.timeNT = Calendar.current.date(byAdding: .weekday, value: -5, to: self!.dateBD)!
                
            case "6 tuần":
                self?.intNT = 60480
                self?.timeNT = Calendar.current.date(byAdding: .weekday, value: -6, to: self!.dateBD)!
                
            case .none:
                break
            case .some(_):
                break
            }
        }
        
        // cell selection style
        menu.cellSelectionStyle = .tickmark
        
        // show empty data label - if needed
        // Note: Default text is 'No data found'
        
        menu.showEmptyDataLabel()
        
        // show as formsheet
        menu.show(style: .formSheet, from: self)
    }
    
    func requestData() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method":"schedue","malh":malh!, "seckey":urlRegister.last!.seckey!]
                InfoScheduleRequest.getInfoSchedules(parameter: param) { [unowned self] (info) in
                    for value in info {
                        
                        self.ngaybdLabel.text = value.ngaybd
                        self.ngayktLabel.text = value.ngaykt
                        self.ngaybd = value.ngaybd
                        self.ngaykt = value.ngaykt
                        self.nhactruocLabel.text = value.ngaynhac
                        self.tieudeTextField.text = value.tieude
                        self.addressTextField.text = value.diadiem
                        self.mandTextField.text = value.noidung
                        self.intNT = Int(value.nhactruoc ?? "") ?? 0
                        self.makh = value.makh
                        self.manvhts = value.manvhts ?? []
                        self.macv = value.macv
                        
                        // get id makh add string Label
                        if value.makh != 0 {
                            let paramMakh: Parameters = ["method": "customer", "makh": value.makh!,"seckey": urlRegister.last!.seckey!]
                            RequestInfoCustomer.getInforCustomer(parameter: paramMakh) { (inforMakh) in
                                for value in inforMakh {
                                    self.makhLabel.text = value.userName
                                }
                            }
                        }
                        
                        if value.macv != "" {
                            do {
                                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                                    let date = Date()
                                    let dateformat = DateFormatter()
                                    dateformat.dateFormat = "dd/MM/yyyy"
                                    let dateString = dateformat.string(from: date)
                                    let previousMonth = Calendar.current.date(byAdding: .month, value: -3, to: date)!
                                    let previousMonthString = dateformat.string(from: previousMonth)
                                    
                                    let param: Parameters = ["method":"tasks","rtype":entity.last!.rtype!, "isadmin": entity.last!.isadmin!, "mact": entity.last!.mact!,"manv":entity.last!.manv!, "mapb": entity.last!.mapb!, "mankd": entity.last!.mankd!, "tungay":previousMonthString,"denngay":dateString,"seckey":urlRegister.last!.seckey!]
                                    
                                    AlertRequestApi.getInfo(param: param, type: .tasks) { [unowned self] (info) in
                                        for valueId in info {
                                            if value.macv == valueId.tasks[0] {
                                                self.macvLabel.text = valueId.tasks[1]
                                            }
                                        }
                                    }
                                }
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                        
                        var arrayString = [String]()
                        if value.manvhts?.count != 0 {
                            for value in value.manvhts! {
                                let param: Parameters = ["method": "staffs","seckey": urlRegister.last!.seckey!]
                                AlertRequestApi.getInfo(param: param, type: .staff) { [unowned self] (info) in
                                    for valueId in info {
                                        if value == Int(valueId.staff[0]) {
                                            arrayString.append(valueId.staff[1])
                                            self.manvhtsLabel.text = arrayString.joined(separator: ", ")
                                            self.simpleSelectedArray.append(valueId.staff[1])
                                        }
                                    }
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
            self?.manvhtsLabel.text = items.joined(separator: ", ")
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
    
    func editSchedule(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                    print("hello")
                                    Alarm.alarm.stopAlarm()
                                    SVProgressHUD.showSuccess(withStatus: "Thành công")
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        Alarm.alarm.checkAlarm()
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
                            } else {
                                SVProgressHUD.dismiss()
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
