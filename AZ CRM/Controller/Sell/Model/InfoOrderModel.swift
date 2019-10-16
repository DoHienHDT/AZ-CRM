//
//  InfoOrderModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
import Alamofire

class InfoOrderModel {
    public var sodh: String
    public var ngaydh: String
    public var diengiai: String
    public var mahtvc: Int
    public var makh: Int
    public var matt: Int?
    public var madktt: Int?
    public var malt: Int?

    init(sodh: String, ngaydh: String, diengiai: String,mahtvc: Int,makh: Int,matt: Int? = nil,madktt: Int? = nil,malt: Int? = nil) {
        self.sodh = sodh
        self.ngaydh = ngaydh
        self.diengiai = diengiai
        self.mahtvc = mahtvc
        self.makh = makh
        self.matt = matt
        self.madktt = madktt
        self.malt = malt
    }
}

class RequestInfoOrder {
    static func getInfoOrder(parameter: Parameters!, completionHandler: @escaping (([InfoOrderModel]) -> ())) {
        APIOnJson(paramer: parameter) { (infoOrder) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [InfoOrderModel]()
            
            if infoOrder != nil {
                let arrayOfOrder = infoOrder!["data"] as! [String: Any]
                let sodh = arrayOfOrder["sodh"] as? String
                let ngaydh = arrayOfOrder["ngaydh"] as? String
                let diengiai = arrayOfOrder["diengiai"] as? String
                let malt = arrayOfOrder["malt"] as? Int
                let mahtvc = arrayOfOrder["mahtvc"] as? Int
                let madktt = arrayOfOrder["madktt"] as? Int
                let makh = arrayOfOrder["makh"] as? Int
                let matt = arrayOfOrder["matt"] as? Int
                
                var dateStringNT = String()
                
                if ngaydh != nil {
                    //Convert timerInterver to date
                    let valueNgaytao = ngaydh ?? ""
                    let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                    let splistNT1 = splistNT[1]
                    let splistNT2 = splistNT1.components(separatedBy: ")/")
                    let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                    dateStringNT = dateformat.string(from: dateNT)
                }
                
                let api: InfoOrderModel = InfoOrderModel(sodh: sodh ?? "", ngaydh: dateStringNT, diengiai: diengiai ?? "", mahtvc: mahtvc ?? 0, makh: makh ?? 0, matt: matt ?? 0, madktt: madktt ?? 0, malt: malt ?? 0)
                    fetchedOrder.append(api)
    
            } else {
                print("api customers nil")
                return
            }
            
            completionHandler(fetchedOrder)
        }
    }
}

