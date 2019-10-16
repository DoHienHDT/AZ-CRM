//
//  EditOrderController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.


import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift

protocol EditOrderControllerDelegate: class {
    func reloadEdit()
}

class EditOrderController: BaseViewController {
    
    @IBOutlet weak var madhLabel: UITextField!
    @IBOutlet weak var ngaydhLabel: UILabel!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var madkttLabel: UILabel!
    @IBOutlet weak var mahtvcLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var maltLabel: UILabel!
    @IBOutlet weak var diengiaiTextField: UITextField!
    @IBOutlet weak var tygiaLabel: UILabel!
    @IBOutlet weak var tranformButton: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var madh: Int?
    var malt: String?
    var madktt: String?
    var mahtvc: String?
    var makh: String?
    var matt: String?
    var myArray = [[String: Any]]()
    var ngaydh: String?
    weak var delegate: EditOrderControllerDelegate!
    
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
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
        
        myArray = []
        tranformButton.cornerRadius = 20
        requestDataOrder()
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func editOrderButton(_ sender: UIButton) {
        SVProgressHUD.show()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    if ngaydhLabel.text != " ",makhLabel.text != " ",mattLabel.text != " ", maltLabel.text != " " {
                        let param: Parameters = ["method":"orderaddorupdate","themmoi":"false", "sodh": madhLabel.text!,"madh":madh!, "manv": entity.last!.manv!, "malt":malt!, "tygia":tygiaLabel.text!, "makh":makh!,"madktt": madktt as Any, "mahtvc":mahtvc as Any, "ngaydh":ngaydhLabel.text!,"ngaygh":"","ngaytt":"","diadiemgiaohang":"","matt":matt!,"diengiai":diengiaiTextField.text ?? "", "sanphams":myArray,"seckey":urlRegister.last!.seckey!]
                        print(param)
                        editOrder(param: param)
                    } else {
                        SVProgressHUD.dismiss()
                        let alertVC = UIAlertController(title: "Bạn cần nhập đủ thông tin của đơn hàng", message: nil, preferredStyle: .alert)
                        
                        alertVC.addAction(title: "Ok", style: .cancel)
                        present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }  catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditListProductOrderController {
            vc.madh = madh
            vc.malt = malt
            vc.madktt = madktt
            vc.mahtvc = mahtvc
            vc.makh = makh
            vc.matt = matt
            vc.sodh = madhLabel.text
            vc.tygia = tygiaLabel.text
            vc.diengiaiEdit = diengiaiTextField.text
            vc.ngaydhOrder = ngaydhLabel.text
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProductButton(_ sender: UIButton) {
        if ngaydhLabel.text != " ",makhLabel.text != " ",mattLabel.text != " ", maltLabel.text != " " {
            self.performSegue(withIdentifier: "listEditOrder", sender: self)
        } else {
            let alertVC = UIAlertController(title: "Bạn cần nhập đủ thông tin của đơn hàng", message: nil, preferredStyle: .alert)
            alertVC.addAction(title: "Ok", style: .cancel)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func ngaydhAlertButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Ngày đơn hàng", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngaydhLabel.text = dateOfBirth
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngaydhLabel.text = self.ngaydh ?? " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func makhAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .customers) { [unowned self] (info) in
            self.makhLabel.text = info?.customer[1] ?? ""
            self.makh = info!.customer[0]
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func madkttAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .orderpaymentmethods) { [unowned self] (info) in
            self.madkttLabel.text = info?.orderpaymentmethods[1]
            self.madktt = info!.orderpaymentmethods[0]
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mahtvcAlertButton(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .ordertransportmethods) { [unowned self] (info) in
            self.mahtvcLabel.text = info?.ordertransportmethods[1]
            self.mahtvc = info!.ordertransportmethods[0]
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mattAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .orderstatus) { (info) in
            
            self.mattLabel.text = info!.orderstatus[1]
            self.matt = info!.orderstatus[0]
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func maltAlertButton(_ sender: UIButton) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAlertAZSoft(Api: .moneytypes) { [unowned self] (info) in
                    self.maltLabel.text = info?.moneytypes[1]
                    self.malt = info!.moneytypes[0]
                    
                    // sau khi lay duoc malt thi requet api 1 lan nua de lay duoc ma ty gia
                    let param: Parameters = ["method":"moneytype","malt": info!.moneytypes[0],"seckey":urlRegister.last!.seckey!]
                    Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                        switch response.result {
                        case .success( _):
                            if let valueString = response.result.value as? [String: Any] {
                                if let data = valueString["data"] as? [String: Any] {
                                    let tygia = data["tygia"] as? Int
                                    self.tygiaLabel.text = String(tygia!)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
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
    
}

extension EditOrderController {
    func editOrder(param: Parameters) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success( _):
                        if let valueString =  response.result.value as? [String: Any]  {
                            if let message = valueString["msg"] as? String {
                                if message == "ok" {
                                    SVProgressHUD.show()
                                    SVProgressHUD.setStatus("Thành công")
                                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                                        self.delegate.reloadEdit()
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
    
    func requestDataOrder() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                
                let paramOrder: Parameters = ["method":"order","madh": madh!, "seckey":urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareProductOpport(parameter: paramOrder) { [unowned self] (product) in
                    for valueSP in product {
                        
                        let dictionary = [
                            "ngaydh": valueSP.ngaydhSP!,
                            "masp": valueSP.maspSP!,
                            "madvt": valueSP.madvtSP!,
                            "soluong": valueSP.soluongSP!,
                            "dongia": valueSP.dongiaSP as Any,
                            "thanhtien": valueSP.thanhtienSP as Any,
                            "sotien": valueSP.sotienSP as Any,
                            "thuegtgt": valueSP.thuegtgtSP as Any,
                            "tiengtgt": valueSP.tiengtgtSP as Any,
                            "tyleck": valueSP.tyleckSP as Any,
                            "tienck": valueSP.tienckSP as Any
                            ] as [String : Any]
                        self.myArray.append(dictionary)
                    }
                }
                
                RequestInfoOrder.getInfoOrder(parameter: paramOrder) { [unowned self] (info) in
                    for valueInfo in info {
                        self.madhLabel.text = valueInfo.sodh
                        self.ngaydhLabel.text = valueInfo.ngaydh
                        self.ngaydh = valueInfo.ngaydh
                        self.diengiaiTextField.text = valueInfo.diengiai
                        self.malt = valueInfo.malt?.description
                        self.madktt = valueInfo.madktt?.description
                        self.mahtvc = valueInfo.mahtvc.description
                        self.makh = valueInfo.makh.description
                        self.matt = valueInfo.matt?.description
                        
                        // get id makh add string Label
                        if valueInfo.makh != 0 {
                            let paramMakh: Parameters = ["method": "customer", "makh": valueInfo.makh,"seckey": urlRegister.last!.seckey!]
                            RequestInfoCustomer.getInforCustomer(parameter: paramMakh) { (inforMakh) in
                                for value in inforMakh {
                                    self.makhLabel.text = value.userName
                                }
                            }
                        }
                        //End
                        
                        // get id malt add string label
                        if valueInfo.malt != 0 {
                            let paramMalt: Parameters = ["method":"moneytypes","seckey":urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMalt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let malt = valueMalt["malt"] as? Int
                                                let tenlt = valueMalt["tenlt"] as? String
                                                
                                                if valueInfo.malt == malt {
                                                    self.maltLabel.text = tenlt
                                                    
                                                    // het id tygia tu api id malt
                                                    let param: Parameters = ["method":"moneytype","malt": malt!,"seckey":urlRegister.last!.seckey!]
                                                    Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                                        switch response.result {
                                                        case .success( _):
                                                            if let valueString = response.result.value as? [String: Any] {
                                                                if let data = valueString["data"] as? [String: Any] {
                                                                    let tygia = data["tygia"] as? Int
                                                                    self.tygiaLabel.text = String(tygia!)
                                                                }
                                                            }
                                                        case .failure(let error):
                                                            print(error)
                                                        }
                                                    })
                                                    // End
                                                }
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            })
                        }
                        // End
                        
                        // get id matt add string label
                        if valueInfo.matt != 0 {
                            let paramMatt: Parameters = ["method": "orderstatus","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let matt = valueMalt["matt"] as? Int
                                                let tentt = valueMalt["tentt"] as? String
                                                
                                                if valueInfo.matt == matt {
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
                        
                        // get id mahtvc add string label
                        if valueInfo.mahtvc != 0 {
                            let paramMahtvc: Parameters = ["method": "ordertransportmethods","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMahtvc, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMahtvc in data {
                                                let mahtvc = valueMahtvc["mahtvc"] as? Int
                                                let tenhtvc = valueMahtvc["tenhtvc"] as? String
                                                
                                                if valueInfo.mahtvc == mahtvc {
                                                    self.mahtvcLabel.text = tenhtvc
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
                        
                        // get id madktt add string label
                        if valueInfo.madktt != 0 {
                            let paramMadktt: Parameters = ["method": "orderpaymentmethods","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMadktt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMadktt in data {
                                                let madktt = valueMadktt["madktt"] as? Int
                                                let tendktt = valueMadktt["tendktt"] as? String
                                                
                                                if valueInfo.madktt == madktt {
                                                    self.madkttLabel.text = tendktt
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
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}

