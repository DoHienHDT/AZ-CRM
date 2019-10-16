//
//  AddSchedulesOpportController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import RSSelectionMenu

class AddSchedulesOpportController: BaseViewController {
    
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var themeTextField: UITextField! // chủ đề
    @IBOutlet weak var nvhtLabel: UILabel!
    @IBOutlet weak var nhactruocLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var manc: Int?
    var noidung: String?
    var ngayxl: String?
    var giatri: String?
    var matt: Int?
    var mahttx: Int?
    var ngaytt: String?
    var thanhtoan: String?
    var manvhts: [Int] = []
    var dateBD = Date()
    var timeNT = Date()
    var intNT = 5
    
    var manv: Int?
    var simpleSelectedArray = [String]()
    
    let myArray = ["5 phút", "10 phút", "20 phút", "30 phút", "1 giờ", "2 giờ", "3 giờ", "4 giờ", "5 giờ", "6 giờ",
                   "7 giờ", "8 giờ ", "9 giờ", "10 giờ", "11 giờ", "12 giờ", "1 ngày", "2 ngày", "3 ngày","4 ngày", "5 ngày",
                   "6 ngày","1 tuần", "2 tuần", "3 tuần", "4 tuần", "5 tuần", "6 tuần"]
    
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
        
        print(manvhts)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ngaybdAlertButton(_ sender: UIButton) {
        
        let dateAdd = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormat.amSymbol = "AM"
        dateFormat.pmSymbol = "PM"
        let todayString = dateFormat.string(from: today)
        self.ngaybdLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày bắt đầu", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: dateAdd, maximumDate: nil) { (date) in
            self.dateBD = date
            self.timeNT = Calendar.current.date(byAdding: .minute, value: -5, to: self.dateBD)!
            
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaybdLabel.text = dateOfBirth
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaybdLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func ngayktAlertButton(_ sender: UIButton) {
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let todayString = dateFormat.string(from: today)
        self.ngayktLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày kết thúc", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: nil) { (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy hh:mm:ss"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngayktLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngayktLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func staffAlertButton(_ sender: UIButton) {
        self.showAsAlertController(style: .actionSheet, title: "Chọn 1 hoặc nhiều nhân viên hỗ trợ", action: "Done", height: nil)
    }
    
    @IBAction func nhactruocAlertButton(_ sender: UIButton) {
        self.showAsFormsheet()
    }
    
    @IBAction func addProcessButton(_ sender: UIButton) {
        if themeTextField.text != "", ngaybdLabel.text != " ", addressTextField.text != "" {
            
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        let param: Parameters = ["method":"opportunityprocessadd",
                                                 "manc":manc!,
                                                 "manv":self.manv ?? 0,
                                                 "manvn":entity.last!.manv!,
                                                 "ngayxl":ngayxl!,
                                                 "thanhtoan":thanhtoan ?? "",
                                                 "giatri":giatri ?? "",
                                                 "ngaytt":ngaytt ?? "",
                                                 "matt":matt!,
                                                 "mahttx":mahttx!,
                                                 "noidung":noidung ?? "",
                                                 "taolichhen":"true",
                                                 "chude":themeTextField.text!,
                                                 "diadiem":addressTextField.text!,
                                                 "ngaybd":ngaybdLabel.text!,
                                                 "ngaykt":ngayktLabel.text ?? "",
                                                 "nhactruoc":intNT,
                                                 "manvhts":manvhts,
                                                 "seckey":urlRegister.last!.seckey!]
                        print(param)
                        addOpportProcess(param: param)
                    }
                }
            }  catch let error {
                print(error.localizedDescription)
            }
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension AddSchedulesOpportController {
    
    func showAsFormsheet() {
        
        /// You can also set selection style - while creating menu instance
        
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: myArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            // cell customization
            // set tint color
            cell.tintColor = UIColor.orange
        }
        
        // provide - selected items and selection delegate
        
        menu.setSelectedItems(items: simpleSelectedArray) { [weak self] (name, index, selected, selectedItems) in
            self?.simpleSelectedArray = selectedItems
            
            self?.nhactruocLabel.text = name
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
                                    Alarm.alarm.stopAlarm()
                                  
                                    
                                    SVProgressHUD.show()
                                    SVProgressHUD.setStatus("Thành công")
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        Alarm.alarm.checkAlarm()
                                        CheckPerform.shared.checkDismis = true
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
    
    // alert multipe selected nvht api staff
    func showAsAlertController(style: UIAlertController.Style, title: String?, action: String?, height: Double?) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let selectionStyle: SelectionStyle = style == .alert ? .single : .multiple
                
                var manvArray: [String] = []
                var nameArray: [String] = []
                
                let paramManv: Parameters = ["method": "staffs","seckey": urlRegister.last!.seckey!]
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramManv, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString = response.result.value as? [String: Any] {
                            if let data = valueString["data"] as? [[String: Any]] {
                                for value in data {
                                    let manvId = value["manv"] as? Int
                                    let hoten = value["hoten"] as? String
                                    manvArray.append(manvId?.description ?? "")
                                    nameArray.append(hoten ?? "")
                                }
                                
                                let selectionMenu = RSSelectionMenu(selectionStyle: selectionStyle, dataSource: manvArray) { (cell, name, indexPath) in
                                    cell.textLabel?.text = nameArray[indexPath.row]
                                }
                                
                                // provide selected items
                                selectionMenu.setSelectedItems(items: self.simpleSelectedArray) { (text, index, isSelected, selectedItems) in
                                }
                                
                                // on dismiss handler
                                selectionMenu.onDismiss = { [weak self] items in
                                    self?.manvhts = []
                                    if items.count != 0 {
                                        
                                        for value in items {
                                            self?.manvhts.append(Int(value) ?? 0)
                                        }
                                        
                                        self?.simpleSelectedArray = items
                                        
                                        if style == .alert {
                                            
                                        } else {
                                            var hotenString: [String] = []
                                            for value in data {
                                                
                                                let manvId = value["manv"] as? Int
                                                let hoten = value["hoten"] as? String
                                                for manvID in items {
                                                    if Int(manvID) == manvId {
                                                        hotenString.append(hoten ?? "")
                                                    }
                                                }
                                            }
                                            self?.nvhtLabel.text = hotenString.joined(separator: ", ")
                                        }
                                    } else {
                                        self?.nvhtLabel.text = " "
                                    }
                                }
                                
                                // cell selection style
                                selectionMenu.cellSelectionStyle = .tickmark
                                
                                // show - with action (if provided)
                                let menuStyle: PresentationStyle = style == .alert ? .alert(title: title, action: action, height: height) : .actionSheet(title: title, action: action, height: height)
                                
                                selectionMenu.show(style: menuStyle, from: self)
                            }
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error: \(error.localizedDescription)", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok",style: .cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

