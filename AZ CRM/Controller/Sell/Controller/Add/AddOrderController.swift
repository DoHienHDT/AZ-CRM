//
//  AddOrderController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift

class AddOrderController: BaseViewController, AddProductControllerDelegate {
    
    @IBOutlet weak var masoLabel: UILabel!
    @IBOutlet weak var ngaydhLabel: UILabel!
    @IBOutlet weak var doituongLabel: UILabel!
    @IBOutlet weak var dkttLabel: UILabel!
    @IBOutlet weak var htvcLabel: UILabel!
    @IBOutlet weak var hanTTLabel: UILabel!
    @IBOutlet weak var ngayGhLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var loaiTienLabel: UILabel!
    @IBOutlet weak var tygiaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heighTableview: NSLayoutConstraint!
    @IBOutlet weak var transionButton: UIButton!
    @IBOutlet weak var diengiaiTextField: UITextField!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var donhang: String?
    var malt: Int?
    var makh: Int?
    var madktt: Int?
    var mahtvc: Int?
    var matt: Int?
    
    var product = [DelegateDataProduct]()
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
        
        transionButton.cornerRadius = 25
        tableView.isHidden = true
        heighTableview.constant = 1
        
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
    }
    
    @objc func dissmisTextField() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.tableView.reloadData()
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "ordercode","seckey": urlRegister.last!.seckey!]
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
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addProductButton(_ sender: Any) {
        
        //Lấy dữ liệu từ coreData
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                if masoLabel.text != " ", loaiTienLabel.text != " ", doituongLabel.text != " ", ngaydhLabel.text != " ", statusLabel.text != " "{
                    
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
                    
                    let param: Parameters = ["method":"orderaddorupdate","themmoi":"true", "sodh": masoLabel.text!, "manv": entity.last!.manv!, "malt":malt as Any, "tygia":tygiaLabel.text as Any, "makh":makh as Any,"madktt": madktt as Any, "mahtvc":mahtvc as Any, "ngaydh":ngaydhLabel.text as Any,"ngaygh":ngayGhLabel.text ?? "","ngaytt":hanTTLabel.text ?? "","diadiemgiaohang":addressTextField.text ?? "","matt":matt!, "sanphams":myProduct,"diengiai":diengiaiTextField.text ?? "","seckey":urlRegister.last!.seckey!]
                    print(param)
                    addOrder(param: param)
                } else {
                    let alertVC = UIAlertController(title: "Bạn cần nhập đủ thông tin cơ hội và sản phẩm", message: nil, preferredStyle: .alert)
                    alertVC.addAction(title: "Ok", style: .cancel)
                    present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // api khach hang
    @IBAction func doituongAlertButton(_ sender: Any) {
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
    
    @IBAction func dkttAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .orderpaymentmethods) { [unowned self] (info) in
            self.dkttLabel.text = info?.orderpaymentmethods[1]
            self.madktt = Int(info!.orderpaymentmethods[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ngaydhAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngaydhLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày đơn hàng", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
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
    
    @IBAction func htvcAlertButton(_ sender: UIButton) {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .ordertransportmethods) { [unowned self] (info) in
            self.htvcLabel.text = info?.ordertransportmethods[1]
            self.mahtvc = Int(info!.ordertransportmethods[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func statusAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .orderstatus) { (info) in

            self.statusLabel.text = info!.orderstatus[1]
            self.matt = Int(info!.orderstatus[0])
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func hanTTAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.hanTTLabel.text = todayString
        
        let alert = UIAlertController(title: "Hạn thanh toán", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.hanTTLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.hanTTLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func ngayGhAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.ngayGhLabel.text = todayString
        
        let alert = UIAlertController(title: "Ngày giao hàng", message: "Select Date", preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.ngayGhLabel.text = dateOfBirth
            print(dateOfBirth)
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.ngayGhLabel.text = " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func loaiTienAlertButton(_ sender: Any) {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAlertAZSoft(Api: .moneytypes) { [unowned self] (info) in
                    self.loaiTienLabel.text = info?.moneytypes[1]
                    self.malt = Int(info!.moneytypes[0])
                    // sau khi lay duoc malt thi requet api 1 lan nua de lay duoc ma ty gia
                    DispatchQueue.main.async {
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
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func senData(productLabel: String, dvtLabel: String, soluongTextField: String, dongiaTextField: String, thanhtienLabel: String, tyleCkTextField: String, tienCKTextField: String, vatTextField: String, tienVatTextField: String, tongTienTextField: String, masp: Int, madvt: Int, ngaydh: String, diengiai: String) {
        let data: DelegateDataProduct = DelegateDataProduct(productLabel: productLabel, dvtLabel: dvtLabel, soluongTextField: soluongTextField, dongiaTextField: dongiaTextField, thanhtienLabel: thanhtienLabel, tyleCkTextField: tyleCkTextField, tienCKTextField: tienCKTextField, vatTextField: vatTextField, tienVatTextField: tienVatTextField, tongTienTextField: tongTienTextField, masp: masp, madvt: madvt, ngaydh: ngaydh, diengiai: diengiai)
        tableView.isHidden = false
        heighTableview.constant = 230
        self.product.append(data)
        self.tableView.reloadData()
    }
    
    @IBAction func createButton(_ sender: Any) {
        
        let storyboad = UIStoryboard(name: "AddOpportController", bundle: nil)
        if let vc = storyboad.instantiateViewController(withIdentifier: "AddProduct") as? AddProductController {
            vc.delegate = self
            vc.heightView = 0
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func diemGHAlertButton(_ sender: Any) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.addLocationPicker { (_) in
//
//        }
//        alert.addAction(title: "Cancel", style: .cancel)
//        present(alert, animated: true, completion: nil)
    }
    
}

extension AddOrderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sản phẩm"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func addOrder(param: Parameters) {
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
                                        self.dismiss(animated: true, completion: nil)
                                    })
                                } else {
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

