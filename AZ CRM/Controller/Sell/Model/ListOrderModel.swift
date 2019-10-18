//
//  ListOrderModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//
import UIKit
import Alamofire

class ListOrderModel {
    var madh: Int
    var sodh: String
    var ngaydh: String
    var doituong: String
    var diadiemgiaohang: String
    var sotien: Int
    var nhanvien: String
    
    init(madh: Int, sodh: String, ngaydh: String, doituong: String, diadiemgiaohang: String, sotien: Int, nhanvien: String) {
        self.madh = madh
        self.sodh = sodh
        self.ngaydh = ngaydh
        self.doituong = doituong
        self.diadiemgiaohang = diadiemgiaohang
        self.sotien = sotien
        self.nhanvien = nhanvien
    }
}

class RequestListOerder  {
    static func getOrder(parameter: Parameters!, completionHandler: @escaping (([ListOrderModel]) -> ())) {
        APIOnJson(paramer: parameter) { (order) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [ListOrderModel]()
            if order != nil {
                if let msg =  order?["msg"] as? String {
                    if msg == "ok" {
                        let arrayOfOrder = order!["data"] as! [[String: Any]]
                                      for valueOrder in arrayOfOrder {
                                          
                                          let madh = valueOrder["madh"] as? Int
                                          let sodh = valueOrder["sodh"] as? String
                                          let ngaydh = valueOrder["ngaydh"] as? String
                                          let doituong = valueOrder["doituong"] as? String
                                          let diadiemgiaohang = valueOrder["diadiemgiaohang"] as? String
                                          let sotien = valueOrder["sotien"] as? Int
                                          let nhanvien = valueOrder["nhanvien"] as? String
                                          
                                          //Convert timerInterver to date
                                          let valueNgaytao = ngaydh ?? ""
                                          let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                                          let splistNT1 = splistNT[1]
                                          let splistNT2 = splistNT1.components(separatedBy: ")/")
                                          let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                                          let dateStringNT = dateformat.string(from: dateNT)
                                          
                                          let api: ListOrderModel = ListOrderModel(madh: madh ?? 0, sodh: sodh ?? "", ngaydh: dateStringNT, doituong: doituong ?? "", diadiemgiaohang: diadiemgiaohang ?? "", sotien: sotien ?? 0, nhanvien: nhanvien ?? "")
                                          fetchedOrder.append(api)
                                        }
                            }
                }
            } else {
                print("api customers nil")
                return
            }
            completionHandler(fetchedOrder)
        }
    }
}

