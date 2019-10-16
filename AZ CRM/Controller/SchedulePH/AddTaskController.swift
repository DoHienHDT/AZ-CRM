//
//  AddTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift
protocol AddTaskControllerDelegate: class {
    func reloadDataAdd()
}

class AddTaskController: BaseViewController, AddStaffTaskControllerDelegate {
    
    @IBOutlet weak var tencvTextField: UITextField!
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var malcvLabel: UILabel!
    @IBOutlet weak var mamdLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var staffButton: UIButton!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var infoStaf = [DelegateStaff]()
    var myProduct = [[String: Any]]()
    var delegate: AddTaskControllerDelegate!
    var makh: Int?
    var malcv: Int?
    var matt: Int?
    var mamd: Int?
    
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                     print(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
                topButtonRight.constant = CGFloat(entity.last!.heightTopButtonRight)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        let date = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        let dateString = dateformat.string(from: date)
        ngaybdLabel.text = dateString
        
        staffButton.cornerRadius = 20
        tableView.isHidden = true
        heightTableView.constant = 1
        tableView.register(UINib(nibName: "InfoStaffTaskCell", bundle: nil), forCellReuseIdentifier: "InfoStaffTaskCell")
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func ngaybdAlertButton(_ sender: UIButton) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngaybdLabel.text = todayString
        
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
            self.ngaybdLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func ngayktAlertButton(_ sender: UIButton) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngayktLabel.text = todayString
        
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
            self.ngayktLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
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
    
    @IBAction func malcvAlertButton(_ sender: UIButton) {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .tasktypes) { [unowned self] (info) in
            self.malcvLabel.text = info?.tasktypes[1]
            self.malcv = Int(info!.tasktypes[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addStaffButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addStaff", sender: self)
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
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddStaffTaskController {
            vc.delegate = self
        }
    }
    
    func senData(vitri: String, nhanvien: String, diengiai: String, mavt: Int, manv: Int) {
        let data: DelegateStaff = DelegateStaff(vitri: vitri, nhanvien: nhanvien, diengiai: diengiai, mavt: mavt, manv: manv)
        
        tableView.isHidden = false
        heightTableView.constant = 230
        infoStaf.append(data)
        tableView.reloadData()
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        SVProgressHUD.show()
        if ngaybdLabel.text != " ", ngayktLabel.text != " ", malcvLabel.text != " ", mattLabel.text != " ", mamdLabel.text != " ", tencvTextField.text != "" {
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    self.myProduct = []
                    if infoStaf.count != 0 {
                        for vlaueSp in infoStaf {
                            let dictionary = [
                                "manv": vlaueSp.manv,
                                "mavt": vlaueSp.mavt,
                                "diengiai": vlaueSp.diengiai
                                ] as [String : Any]
                            myProduct.append(dictionary)
                        }
                        
                        let param: Parameters = ["method":"taskaddorupdate","themmoi":"true","manv":entity.last!.manv!,"makh":makh  ?? 0,"ngaybd":ngaybdLabel.text!, "ngaykt":ngayktLabel.text!, "malcv":malcv!, "matt":matt!, "mamd":mamd!, "diengiai":contentTextField.text ?? "", "tencv":tencvTextField.text!, "nhanviens":myProduct, "seckey":urlRegister.last!.seckey!]
                        print(param)
                        addTask(param: param)
                    } else {
                        let param: Parameters = ["method":"taskaddorupdate","themmoi":"true","manv":entity.last!.manv!,"makh":makh ?? 0,"ngaybd":ngaybdLabel.text!, "ngaykt":ngayktLabel.text!, "malcv":malcv!, "matt":matt!, "mamd":mamd!, "diengiai":contentTextField.text ?? "", "tencv":tencvTextField.text!, "seckey":urlRegister.last!.seckey!]
                        print(param)
                        addTask(param: param)
                    }
                  }
                }
            } catch {
                SVProgressHUD.dismiss()
                print("error")
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension AddTaskController {
    func addTask(param: Parameters) {
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
                                        self.delegate.reloadDataAdd()
                                        self.dismiss(animated: true, completion: nil)
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

extension AddTaskController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoStaf.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoStaffTaskCell", for: indexPath) as! InfoStaffTaskCell
        cell.manvLabel.text = infoStaf[indexPath.row].nhanvien
        cell.mavtLabel.text = infoStaf[indexPath.row].vitri
        cell.diengiaiLabel.text = infoStaf[indexPath.row].diengiai
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

