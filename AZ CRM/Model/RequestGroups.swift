//
//  RequestGroups.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
import Alamofire

class RequestGroups {

    static func getManhom(parameters: Parameters!, completionHandler: @escaping (([Manhom]) -> ())) {
        APIOnJson(paramer: parameters) { (value) in
            var fetchedContact = [Manhom]()
            
            let arrayManhom = value!["data"] as! [[String: Any]]
         
          
            for contact in arrayManhom {
                guard let manhom = contact["manhom"] as? Int else {return}
                guard let tennhom = contact["tennhom"] as? String else {return}
                
                let textData: Manhom = Manhom(manhom: [String(manhom),tennhom])
                fetchedContact.append(textData)
            }
            completionHandler(fetchedContact)
        }
    }
    
    static func getManguon(parameters: Parameters!, completionHandler: @escaping (([Manguon]) -> ())) {
        APIOnJson(paramer: parameters) { (value) in
            var fetchedContact = [Manguon]()
            
            let arrayManhom = value!["data"] as! [[String: Any]]
            
            
            for contact in arrayManhom {
                guard let manguon = contact["manguon"] as? Int else {return}
                guard let tennguon = contact["tennguon"] as? String else {return}
                
                let textData: Manguon = Manguon(manguon: [String(manguon), tennguon])
                fetchedContact.append(textData)
            }
            completionHandler(fetchedContact)
        }
    }
    
    static func getStaff(parameters: Parameters!, completionHandler: @escaping (([Staff]) -> ())) {
        APIOnJson(paramer: parameters) { (value) in
            var fetchedContact = [Staff]()
            
            let arrayManhom = value!["data"] as! [[String: Any]]
            
            
            for contact in arrayManhom {
                guard let manv = contact["manv"] as? Int else {return}
                guard let hoten = contact["hoten"] as? String else {return}
                guard let maso = contact["maso"] as? String else {return}
                let textData: Staff = Staff(maso: maso, manv: manv, hoten: hoten)
                fetchedContact.append(textData)
            }
            completionHandler(fetchedContact)
        }
    }
    
    static func getMaKH(parameters: Parameters!, completionHandler: @escaping (([CustomerMaKH]) -> ())) {
        APIOnJson(paramer: parameters) { (value) in
            var fetchedContact = [CustomerMaKH]()
            
            let arrayManhom = value!["data"] as! [[String: Any]]
            
            for contact in arrayManhom {
                let makh = contact["makh"] as? Int
                let tencongty = contact["tencongty"] as? String
                
                let textData: CustomerMaKH = CustomerMaKH(makh: [String(makh ?? -999), tencongty ?? "-999"])
                fetchedContact.append(textData)
            }
            completionHandler(fetchedContact)
        }
    }
    
    static func getOpportStatus(parameters: Parameters!, completionHandler: @escaping (([OpportunityStatus]) -> ())) {
        APIOnJson(paramer: parameters) { (value) in
            var fetchedOpport = [OpportunityStatus]()
            
            let arrayOfCustomer = value!["data"] as! [[String: Any]]
            
            for contact in arrayOfCustomer {
                
                let tiemnang = contact["tiemnang"] as? Int
                let matt = contact["matt"] as? Int
                let tentt = contact["tentt"] as? String
             
                let textData: OpportunityStatus = OpportunityStatus(status: [String(tiemnang ?? -1), String(matt ?? -1), tentt ?? ""])
                    fetchedOpport.append(textData)
                
            }
            completionHandler(fetchedOpport)
        }
    }
    
    static func getMaSP(parameters: Parameters!, completionHandler: @escaping (([MaSP]) -> ())) {
        APIOnJson(paramer: parameters) { (mapProduct) in
            var fetchedContact = [MaSP]()
            
            let arrayMaSP = mapProduct!["data"] as! [[String: Any]]
            
            
            for masp in arrayMaSP {
                let tensp = masp["tensp"] as? String
                let soluong = masp["soluong"] as? Int
                let id = masp["id"] as? Int
                
                let textData: MaSP = MaSP(masp: [tensp!, String(soluong ?? -99), String(id!)])
                fetchedContact.append(textData)
            }
            completionHandler(fetchedContact)
        }
    }
    
    static func getMaDVTSP(parameters: Parameters!, completionHandler: @escaping (([MaDvtSP]) -> ())) {
        APIOnJson(paramer: parameters) { (mapProduct) in
            var fetchedContact = [MaDvtSP]()
            
            let arrayMaSP = mapProduct!["data"] as! [[String: Any]]
            
            
            for masp in arrayMaSP {
                let tendvt = masp["tendvt"] as? String
                let madvt = masp["madvt"] as? Int
                
                let textData: MaDvtSP = MaDvtSP(maDvtSp: [tendvt!, String(madvt!)])
                fetchedContact.append(textData)
            }
            completionHandler(fetchedContact)
        }
    }
}


