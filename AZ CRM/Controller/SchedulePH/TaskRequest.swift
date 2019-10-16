//
//  TaskRequest.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
import Alamofire
class TaskRequest {
    static func getTask(parameter: Parameters!, completionHandler: @escaping (([ListTaskModel]) -> ())) {
        APIOnJson(paramer: parameter) { (task) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [ListTaskModel]()
            if task != nil {
                
                let arrayOfTask = task!["data"] as! [[String: Any]]
                for valueTask in arrayOfTask {
                    let macv = valueTask["macv"] as? Int
                    let tencv = valueTask["tencv"] as? String
                    let ngaybd = valueTask["ngaybd"] as? String
                    let ngaykt = valueTask["ngaykt"] as? String
                    let tiendo = valueTask["tiendo"] as? Int
                    let tenkh = valueTask["tenkh"] as? String
                    let trangthai = valueTask["trangthai"] as? String
                    let hoanthanh = valueTask["hoanthanh"] as? Bool
                    let nguoinhap = valueTask["nguoinhap"] as? String
                    
                    var date1 = String()
                    var date2 = String()
                    
                    
                    if ngaybd != nil {
                        let valueNgaytao = ngaybd!
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        date1 = dateformat.string(from: dateNT)
                    }
                    
                    if ngaykt != nil {
                        let valueNgaytao = ngaykt!
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        date2 = dateformat.string(from: dateNT)
                    }
                    
                    let api: ListTaskModel = ListTaskModel(macv: String(macv ?? 0), tencv: tencv ?? "", ngaybd: date1, ngaykt: date2, tiendo: tiendo ?? 0, tenkh: tenkh, trangthai: trangthai ?? "", hoanthanh: hoanthanh!, nguoinhap: nguoinhap ?? "")
                    fetchedOrder.append(api)
                }
            } else {
                print("api customers nil")
                return
            }
            completionHandler(fetchedOrder)
        }
    }
}
