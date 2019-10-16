//
//  InfoOrderController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire

class InfoOrderController: BaseViewController {

    @IBOutlet weak var ngaydhLabel: UILabel!
    @IBOutlet weak var madhLabel: UILabel!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var madkttLabel: UILabel!
    @IBOutlet weak var mahtvcLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var maltLabel: UILabel!
    @IBOutlet weak var tygiaLabel: UILabel!
    @IBOutlet weak var diengiaiTextField: UILabel!
    
    var madh: Int?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDataOrder()
    }
    
    deinit {
        Log("has deinitialized")
    }
  
}

extension InfoOrderController {
    
    func requestDataOrder() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                
                let param: Parameters = ["method":"order","madh": madh ?? 0, "seckey":urlRegister.last!.seckey!]
                
                RequestInfoOrder.getInfoOrder(parameter: param) { [unowned self] (info) in
                    for valueInfo in info {
                        self.madhLabel.text = valueInfo.sodh
                        self.ngaydhLabel.text = valueInfo.ngaydh
                        self.diengiaiTextField.text = valueInfo.diengiai
                        
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
                            let paramMadktt: Parameters = ["method": "orderpaymentmethods","seckey":urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMadktt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMadktt in data {
                                                let madktt = valueMadktt["madktt"] as? Int
                                                let tendktt = valueMadktt["tendktt"] as? String
                                                
                                                if valueInfo.mahtvc == madktt {
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



