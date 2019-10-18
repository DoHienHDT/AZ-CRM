//
//  RequestOport.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class RequestOport {
    static func getOport(parameter: Parameters!, completionHandler: @escaping (([OpportModel]) -> ())) {
        APIOnJson(paramer: parameter) { (oport) in
            
            var fetchedOpport = [OpportModel]()
            
            if oport != nil {
                if let msg = oport?["msg"] as? String {
                    if msg == "ok" {
                        let arrayOfCustomer = oport!["data"] as! [[String: Any]]
                        for valueOport in arrayOfCustomer {
                            
                            var valueGT = Double()
                            
                            let mancOpport = valueOport["manc"] as? Int
                            let dateOpport = valueOport["ngaynhap"] as? String
                            let masoOpport = valueOport["maso"] as? String
                            let nameOpport = valueOport["khachhang"] as? String
                            let valueOpport = valueOport["giatri"] as? Double
                            let potentialOpport = valueOport["tiemnang"] as? Int
                            let telOpport = valueOport["didong"] as? String
                            let emailOpport = valueOport["email"] as? String
                            let makh = valueOport["makh"] as? Int
                            
                            if valueOpport != nil {
                                valueGT = valueOpport!
                            } else {
                                valueGT = 0.0
                            }
                           
                            let textData: OpportModel = OpportModel(mancOpport: mancOpport ?? 0, dateOpport: dateOpport ?? "", masoOpport: masoOpport ?? "", nameOpport: nameOpport ?? "", valueOpport: valueGT, potentialOpport: potentialOpport ?? 0, telOpport: telOpport ?? "", emailOpport: emailOpport ?? "", makh: makh ?? 0)
                            fetchedOpport.append(textData)
                        }
                    }
                }
            } else {
                print("api opportunities nil")
                return
            }
            
            completionHandler(fetchedOpport)
        }
    }
}
