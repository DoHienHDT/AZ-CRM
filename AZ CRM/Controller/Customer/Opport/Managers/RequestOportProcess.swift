//
//  RequestOportProcess.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
import Alamofire
class RequestOportProcess {
    
        static func getOportProcess(parameter: Parameters!, completionHandler: @escaping (([OportProcessModel]) -> ())) {
            APIOnJson(paramer: parameter) { (oportProcess) in

                var fetchedOpport = [OportProcessModel]()
                let dateformat = DateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy"
                
                if oportProcess != nil  {
                    
                    let arrayOportProcess = oportProcess!["data"] as! [[String: Any]]
                    
                    for valueOport in arrayOportProcess {
                        let noidung = valueOport["noidung"] as? String
                        let hinhthuc = valueOport["hinhthuc"] as? String
                        let ngayxl = valueOport["ngayxl"] as? String
                        let ngaytao = valueOport["ngaytao"] as? String
                        let nguoitao = valueOport["nguoitao"] as? String
                        let nguoiquanly = valueOport["nguoiquanly"] as? String
                        
                        var dateStringNT = String()
                        //Convert timerInterver to date
                        if ngaytao != nil {
                            let valueNgaytao = ngaytao!
                            let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                            let splistNT1 = splistNT[1]
                            let splistNT2 = splistNT1.components(separatedBy: ")/")
                            let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                            dateStringNT = dateformat.string(from: dateNT)
                        }
                        
                        var dateStringNXL = String()
                        //Convert timerInterver to date
                        if ngayxl != nil {
                            let valueNgayXL = ngayxl!
                            let splistNXL = valueNgayXL.components(separatedBy: "/Date(")
                            let splistNXL1 = splistNXL[1]
                            let splistNXL2 = splistNXL1.components(separatedBy: ")/")
                            let dateNXL = Date(milliseconds: Int(splistNXL2[0]) ?? 0)
                            dateStringNXL = dateformat.string(from: dateNXL)
                        }
                        
                        let textData: OportProcessModel = OportProcessModel(noidung: noidung ?? "", hinhthuc: hinhthuc ?? "", ngayxl: dateStringNXL , ngaytao: dateStringNT , nguoitao: nguoitao ?? "", nguoiquanly: nguoiquanly ?? "")
                        
                        fetchedOpport.append(textData)
                    }
                } else {
                    print("api opportunityprocess nil")
                    return
                }

                completionHandler(fetchedOpport)
            }
        }
}
