//
//  ListEditProductOpportController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class ListEditProductOpportController: BaseViewController, AddProductControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var imageAdd: UIImageView!
    
    var product = [TakeCareProductModel]()
    var mancOpport: Int?
    var defaultOptions = SwipeOptions()
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    var makh: Int?
    var matt: Int?
    var maso: String?
    var giatri: String?
    var tiemnang: String?
    var diengiaiEdit: String?
    var myArrayProduct = [[String: Any]]()
    var valueStringDelete = [[String: Any]]()
    var manvhts = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        imageAdd.layer.cornerRadius = imageAdd.frame.height/2
        imageAdd.layer.shadowRadius = 20
        imageAdd.layer.shadowOpacity = 0.8
        imageAdd.layer.shadowColor = UIColor.black.cgColor
        imageAdd.layer.shadowOffset = CGSize.zero
        
        imageAdd.generateEllipticalShadow()
        
        self.buttonStyle = .circular
        self.defaultOptions.transitionStyle = .reveal
        tableView.register(UINib(nibName: "TakeCareOpportProductCell", bundle: nil), forCellReuseIdentifier: "TakeCareOpportProductCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiOportProcess()
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func addProductButton(_ sender: UIButton) {
        let storyboad = UIStoryboard(name: "AddOpportController", bundle: nil)
        if let vc = storyboad.instantiateViewController(withIdentifier: "AddProduct") as? AddProductController {
            vc.delegate = self
            vc.heightView = 70
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func senData(productLabel: String, dvtLabel: String, soluongTextField: String, dongiaTextField: String, thanhtienLabel: String, tyleCkTextField: String, tienCKTextField: String, vatTextField: String, tienVatTextField: String, tongTienTextField: String, masp: Int, madvt: Int, ngaydh: String, diengiai: String) {
        
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    
                    myArrayProduct = []
                    let param: Parameters = ["method": "opportunity","manc": mancOpport!,"seckey": urlRegister.last!.seckey!]
                    RequestTakeCareOpport.getTakeCareProductOpport(parameter: param) { [unowned self] (product) in
                        var dictionary = [String: Any]()
                        for valueProduct in product {
                            dictionary = [
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
                            ]
                            self.myArrayProduct.append(dictionary)
                        }
                        
                        let dictionary1 = [
                            "ngaydh": ngaydh,
                            "masp": masp,
                            "madvt": madvt,
                            "soluong": soluongTextField,
                            "dongia": dongiaTextField,
                            "thanhtien": thanhtienLabel,
                            "sotien": tongTienTextField,
                            "thuegtgt": vatTextField,
                            "tiengtgt": tienVatTextField,
                            "tyleck": tyleCkTextField,
                            "tienck": tienCKTextField,
                            "diengiai": diengiai
                            ] as [String : Any]
                        
                        self.myArrayProduct.append(dictionary1)
                        
                        
                        let param: Parameters = ["method": "opportunityaddorupdate", "themmoi": "false" , "maso": self.maso ?? "", "manc":self.mancOpport!, "makh":self.makh!,"matt":self.matt!,"manv": entity.last!.manv!,"tiemnang":self.tiemnang!,"giatri":self.giatri ?? "", "manvhts": self.manvhts,"sanphams": self.myArrayProduct,"diengiai":self.diengiaiEdit ?? "","seckey": urlRegister.last!.seckey!]
                        print(param)
                        self.editOpport(param: param)
                        
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ListEditProductOpportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakeCareOpportProductCell", for: indexPath) as! TakeCareOpportProductCell
        
        if product[indexPath.row].tienckSP == 0.0 {
            cell.tienckLabel.text  = "0"
        } else {
            cell.tienckLabel.text = product[indexPath.row].tienckSP?.description
        }
        
        if product[indexPath.row].tiengtgtSP == 0.0 {
            cell.tienvatLabel.text  = "0"
        } else {
            cell.tienvatLabel.text = product[indexPath.row].tiengtgtSP?.description
        }
        
        if product[indexPath.row].sotienSP == 0.0 {
            cell.tongtienLabel.text  = "0"
        } else {
            cell.tongtienLabel.text = product[indexPath.row].sotienSP?.description
        }
        
        cell.maspLabel.text = product[indexPath.row].maspString
        cell.soluongLabel.text = product[indexPath.row].soluongSP?.description
        cell.thanhtienLabel.text = product[indexPath.row].thanhtienSP?.description
        cell.dienGiaiLabel.text = product[indexPath.row].diengiaiSP
        cell.dongiaLabel.text = product[indexPath.row].dongiaSP?.description
        cell.tenSpLabel.text = product[indexPath.row].tenspSP
        cell.heightDGLabel.text = "Diễn giải"
        cell.delegate = self
        
        return cell
    }
    
    func apiOportProcess() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunity","manc": mancOpport!,"seckey": urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareProductOpport(parameter: param) { [unowned self] (product) in
                    self.product = product
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func apiReloadTableViewProduct() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunity","manc": mancOpport!,"seckey": urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareProductOpport(parameter: param) { [unowned self] (product) in
                    self.product = product
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
}

extension ListEditProductOpportController {
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
                                        self.apiReloadTableViewProduct()
                                    })
                                }   else {
                                    SVProgressHUD.dismiss()
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

extension ListEditProductOpportController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let edit = SwipeAction(style: .default, title: nil) { (_, _) in
                if let storyboad = self.storyboard {
                    if let vc = storyboad.instantiateViewController(withIdentifier: "EditProductOpportController") as? EditProductOpportController {
                        vc.id = self.product[indexPath.row].id
                        vc.makh = self.makh
                        vc.matt = self.matt
                        vc.giatri = self.giatri
                        vc.tiemnang = self.tiemnang
                        vc.mancOpport = self.mancOpport
                        vc.manvhts = self.manvhts
                        vc.maso = self.maso
                        vc.diengiaiEdit = self.diengiaiEdit
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
            edit.hidesWhenSelected = true
            configure(action: edit, with: .edit)
            
            let delete = SwipeAction(style: .default, title: nil) { action, indexPath in
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let openActionCancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
                let openActionDelete = UIAlertAction(title: "Xoá", style: .destructive, handler: { (_) in
                    self.valueStringDelete = []
                    SVProgressHUD.show()
                    let id = self.product[indexPath.row].id
                    for valueProduct in self.product {
                        if valueProduct.id != id {
                            
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
                            self.valueStringDelete.append(dictionary)
                        }
                    }
                    do {
                        if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                                let param: Parameters = ["method": "opportunityaddorupdate", "themmoi": "false" , "manc":self.mancOpport!, "makh":self.makh!,"matt":self.matt!,"manv": entity.last!.manv!,"tiemnang":self.tiemnang!,"sanphams": self.valueStringDelete,"giatri":self.giatri ?? "","diengiai":self.diengiaiEdit ?? "","seckey": urlRegister.last!.seckey!]
                                self.editOpport(param: param)
                            }
                        }
                    }  catch let error {
                        print(error.localizedDescription)
                    }
                })
                alert.addAction(openActionDelete)
                alert.addAction(openActionCancel)
                self.present(alert, animated: true, completion: nil)
            }
            configure(action: delete, with: .trash)
            
            return[delete,edit]
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .selection
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        }
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
    
}

