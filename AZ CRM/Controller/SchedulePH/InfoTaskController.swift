//
//  InfoTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class InfoTaskController: BaseViewController {

    var macv: Int?
    
    @IBOutlet weak var tencvLabel: UILabel!
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var maloaiLabel: UILabel!
    @IBOutlet weak var mamdLabel: UILabel!
    @IBOutlet weak var noidungLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDataInfoTask()
    }
    
    deinit {
        Log("has deinitialized")
    }
    
}

extension InfoTaskController {
    
    func requestDataInfoTask() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                InfoTaskRequest.getInfoTask(parameter: param) { [unowned self ] (infoTask) in
                    
                    for value in infoTask {
                        self.tencvLabel.text = value.tencv
                        self.ngaybdLabel.text = value.ngaybd
                        self.ngayktLabel.text = value.ngaykt
                        self.noidungLabel.text = value.noidung
                        
                        // get id matt add string label
                        if value.matt != 0 {
                            let paramMatt: Parameters = ["method": "taskstatus","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let matt = valueMalt["matt"] as? Int
                                                let tentt = valueMalt["tentt"] as? String
                                                
                                                if value.matt == matt {
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
                        
                        // get id mamd add string label
                        if value.mamd != 0 {
                            let paramMatt: Parameters = ["method": "taskprios","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let mamd = valueMalt["mamd"] as? Int
                                                let tenmd = valueMalt["tenmd"] as? String
                                                
                                                if value.mamd == mamd {
                                                    self.mamdLabel.text = tenmd
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
                        
                        // get id maloai add string label
                        if value.maloai != 0 {
                            let paramMatt: Parameters = ["method": "tasktypes","seckey": urlRegister.last!.seckey!]
                            Alamofire.request(urlRegister.last!.data!, method: .post, parameters: paramMatt, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                                switch response.result {
                                case .success( _):
                                    if let valueString = response.result.value as? [String: Any] {
                                        if let data = valueString["data"] as? [[String: Any]] {
                                            for valueMalt in data {
                                                let malcv = valueMalt["malcv"] as? Int
                                                let tenloaicv = valueMalt["tenloaicv"] as? String
                                                
                                                if value.maloai == malcv {
                                                    self.maloaiLabel.text = tenloaicv
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
                        
                        // get id makh add string Label
                        if value.makh != 0 {
                            let paramMakh: Parameters = ["method": "customer", "makh": value.makh,"seckey": urlRegister.last!.seckey!]
                            RequestInfoCustomer.getInforCustomer(parameter: paramMakh) { (inforMakh) in
                                for value in inforMakh {
                                    self.makhLabel.text = value.userName
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
}


