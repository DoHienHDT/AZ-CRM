//
//  AlertRequestApi.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
import UIKit
import Alamofire

struct AlertRequestApi {
    
    public enum type {
        case customers
        case opportunitystatus
        case products
        case units
        case staff
        case customerGroups
        case customersources
        case orderstatus
        case orderpaymentmethods
        case ordertransportmethods
        case moneytypes
        case opportunitymeettypes
        case tasktypes
        case taskprios
        case taskstatus
        case tasktitles
        case companies
        case tasks
    }
    
    // những trường có [String] là lấy cả string va int (string để hiển thị, int để đẩy lên api)
    public static func getInfo(param: Parameters,type: type,completionHandler: @escaping ([AlertRequestApiInfo]) -> ()) {
        APIOnJson(paramer: param) { (listData) in
            var result = [AlertRequestApiInfo]()
            
            switch type {
            case .customers:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let makh = data["makh"] as? Int
                        let tencongty = data["tencongty"] as? String
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(customer: [String(makh ?? 0), tencongty ?? ""])
                        result.append(textData)
                    }
                }
                break
            case .opportunitystatus:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        
                        let tiemnang = data["tiemnang"] as? Int
                        let matt = data["matt"] as? Int
                        let tentt = data["tentt"] as? String
                        if tiemnang != nil, matt != nil {
                            let textData: AlertRequestApiInfo = AlertRequestApiInfo(opportunitystatus: [String(tiemnang ?? 0),tentt ?? "",String(matt ?? 0)])
                            result.append(textData)
                        }
                    }
                }
                break
            case .products:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                       let value = data["tensp"] as? String
                       let soluong = data["soluong"] as? Int
                       let id = data["id"] as? Int
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(product: [value ?? "","\(soluong ?? 0)", String(id ?? 0)])
                        result.append(textData)
                    }
                }
                break
            case .units:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let value = data["tendvt"] as? String
                        let madvt = data["madvt"] as? Int
                        if value != "", madvt != nil {
                            let textData: AlertRequestApiInfo = AlertRequestApiInfo(dvtProduct: [String(madvt ?? 0), value ?? ""])
                            result.append(textData)
                        }
                    }
                }
                break
            case .staff:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let value = data["hoten"] as? String else {return}
                        let maso = data["maso"] as? String
                        let manv = data["manv"] as? Int
                        
                        if value != "" {
                            let textData: AlertRequestApiInfo = AlertRequestApiInfo(staff: [String(manv ?? 0),value, maso ?? ""])
                            result.append(textData)
                        }
                    }
                }
                break
            case .customerGroups:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let manhom = data["manhom"] as? Int else {return}
                        guard let value = data["tennhom"] as? String else {return}
                        if value != "" {
                            let textData: AlertRequestApiInfo = AlertRequestApiInfo(customerGroups: [String(manhom),value])
                            result.append(textData)
                        } else {
                            print("nil")
                        }
                    }
                }
                break
            case .customersources:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let tennguon = data["tennguon"] as? String else {return}
                        guard let manguon = data["manguon"] as? Int else {return}
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(customersources: [String(manguon),tennguon])
                            result.append(textData)
                    }
                }
                break
            case .orderstatus:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let matt = data["matt"] as? Int else {return}
                        guard let tentt = data["tentt"] as? String else {return}
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(orderstatus: [String(matt),tentt])
                        result.append(textData)
                    }
                }
                break
            case .orderpaymentmethods:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let madktt = data["madktt"] as? Int else {return}
                        guard let tendktt = data["tendktt"] as? String else {return}
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(orderpaymentmethods: [String(madktt),tendktt])
                        result.append(textData)
                    }
                }
                break
            case .ordertransportmethods:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let mahtvc = data["mahtvc"] as? Int else {return}
                        guard let tenhtvc = data["tenhtvc"] as? String else {return}
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(ordertransportmethods: [String(mahtvc),tenhtvc])
                        result.append(textData)
                    }
                }
                break
            case .moneytypes:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let malt = data["malt"] as? Int else {return}
                        guard let tenlt = data["tenlt"] as? String else {return}
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(moneytypes: [String(malt),tenlt])
                        result.append(textData)
                    }
                }
                break
                
            case .opportunitymeettypes:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        guard let maht = data["maht"] as? Int else {return}
                        guard let tenht = data["tenht"] as? String else {return}
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(opportunitymeettypes: [String(maht), tenht])
                        result.append(textData)
                    }
                }
                break
                
            case .tasktypes:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let malcv = data["malcv"] as? Int
                        let tenloaicv = data["tenloaicv"] as? String
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(tasktypes: [String(malcv ?? 0), tenloaicv ?? ""])
                        result.append(textData)
                    }
                }
                break
                
            case .taskprios:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let mamd = data["mamd"] as? Int
                        let tenmd = data["tenmd"] as? String
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(taskprios: [String(mamd ?? 0), tenmd ?? ""])
                        result.append(textData)
                    }
                }
                break
            case .taskstatus:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let matt = data["matt"] as? Int
                        let tentt = data["tentt"] as? String
                        
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(taskstatus: [String(matt ?? 0), tentt ?? ""])
                        result.append(textData)
                    }
                }
                break
            case .tasktitles:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let mavitri = data["mavitri"] as? Int
                        let tenvitri = data["tenvitri"] as? String
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(tasktitles: [String(mavitri ?? 0), tenvitri ?? ""])
                        result.append(textData)
                    }
                }
                break
            case .companies:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let mact = data["mact"] as? Int
                        let tenct = data["tenct"] as? String
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(companies: [String(mact ?? 0), tenct ?? ""])
                        result.append(textData)
                    }
                }
                break
            case .tasks:
                if listData != nil {
                    let arrayData = listData!["data"] as! [[String: Any]]
                    
                    for data in arrayData {
                        let macv = data["macv"] as? Int
                        let tencv = data["tencv"] as? String
                        let textData: AlertRequestApiInfo = AlertRequestApiInfo(tasks: [String(macv ?? 0), tencv ?? ""])
                        result.append(textData)
                    }
                }
                break
            }
            completionHandler(result)
        }
    }
}

