//
//  RequetsContact.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
import Alamofire
class RequestContacts {
    static func getContact(parameter: Parameters!, completionHandler: @escaping (([ContactModel]) -> ())) {
        APIOnJson(paramer: parameter) { (contact) in
            
            var fetchedCustomer = [ContactModel]()
            
            if contact != nil {
                
                let valueContact = contact!["data"] as! [[String: Any]]
                
                for value in valueContact {
                    let valueMaso = value["maso"] as? String
                    let valueName = value["hoten"] as? String
                    let valueEmail = value["email"] as? String
                    let valuePhone = value["didong"] as? String
                    let valueMalh = value["malh"] as? Int
                    let tenkh = value["tenkh"] as? String
                    let makh = value["makh"] as? Int
                    
                    let textData: ContactModel = ContactModel(company: valueName ?? "", mail: valueEmail ?? "", phone: valuePhone ?? "", maso: valueMaso ?? "", malh: valueMalh ?? 0, tenkh: tenkh ?? "", makh: makh ?? 0)
                    fetchedCustomer.append(textData)
                }
            } else {
                print("api contacts nil")
                return
            }
            
            completionHandler(fetchedCustomer)
        }
    }
}

class RequestInfoContact {
    static func getInfoContact(parameter: Parameters!, completionHandler: @escaping (([ListInforContactModel]) -> ())) {
        APIOnJson(paramer: parameter) { (infoContact) in
            
            var fetchedCustomer = [ListInforContactModel]()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            
            if infoContact != nil {
                let valueContact = infoContact!["data"] as! [String: Any]
                
                let valueMalh = valueContact["maso"] as? String
                let valueName = valueContact["hoten"] as? String
                let valueEmail = valueContact["email"] as? String
                let valueTel = valueContact["didong"] as? String
                let didongkhac = valueContact["didongkhac"] as? String
                let valuePosition = valueContact["chucvu"] as? String
                let valueNote = valueContact["ghichu"] as? String
                let valueManv = valueContact["manv"] as? Int
                let valueMakh = valueContact["makh"] as? Int
                let ngaysinh = valueContact["ngaysinh"] as? String
              
                
                var dateStringNT = String()
                if ngaysinh != nil {
                    //Convert timerInterver to date
                    let valueNgaytao = ngaysinh ?? ""
                    let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                    let splistNT1 = splistNT[1]
                    let splistNT2 = splistNT1.components(separatedBy: ")/")
                    let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                    dateStringNT = dateformat.string(from: dateNT)

                }
                
                let textData: ListInforContactModel = ListInforContactModel(position: valuePosition ?? "", name: valueName ?? "", tel: valueTel ?? "", phone: didongkhac ?? "", mail: valueEmail ?? "", note: valueNote ?? "", malh: valueMalh ?? "", manv: valueManv ?? 0, makh: valueMakh ?? 0, diachi: valuePosition ?? "", ngaysinh: dateStringNT)
                fetchedCustomer.append(textData)
            } else {
                print("api contact nil")
                return
            }
            
            completionHandler(fetchedCustomer)
        }
    }
}
