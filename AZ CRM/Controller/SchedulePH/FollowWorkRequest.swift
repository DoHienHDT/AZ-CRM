//
//  FollowWorkRequest.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
import Alamofire
class FollowWorkRequest {
    static func getfollow(parameter: Parameters!, completionHandler: @escaping (([FollowWorkModel]) -> ())) {
        APIOnJson(paramer: parameter) { (follow) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [FollowWorkModel]()
            if follow != nil {
                
                let arrayOfTask = follow!["data"] as! [[String: Any]]
                
                for valueFollow in arrayOfTask {
                    
                    let ngaynhap = valueFollow["ngaynhap"] as? String
                    let noidung = valueFollow["noidung"] as? String
                    let tiendo = valueFollow["tiendo"] as? Int
                    let macv = valueFollow["macv"] as? Int
                    let manvn = valueFollow["manvn"] as? Int
                    let ngayxl = valueFollow["ngayxl"] as? String
                    let nguoinhap = valueFollow["nguoinhap"] as? String
                    
                    var date1 = String()
                    var date2 = String()
                    
                    if ngaynhap != nil {
                        let valueNgaytao = ngaynhap!
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        date1 = dateformat.string(from: dateNT)
                    }
                    
                    if ngayxl != nil {
                        let valueNgaytao = ngayxl!
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        date2 = dateformat.string(from: dateNT)
                    }
                    
                    let api: FollowWorkModel = FollowWorkModel(ngaynhap: date1, noidung: noidung ?? "", tiendo: tiendo ?? 0, macv: macv ?? 0, manvn: manvn ?? 0, ngayxl: date2, nguoinhap: nguoinhap ?? "")

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
