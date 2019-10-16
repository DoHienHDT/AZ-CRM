//
//  RequestInfoCustomer.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SVProgressHUD
class RequestInfoCustomer {
    
    static func getInforCustomer(parameter: Parameters!, completionHandler: @escaping (([InforCustomer]) -> ())) {
        APIOnJson(paramer: parameter) { (customer) in
            
            var fetchedCustomer = [InforCustomer]()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            
            if customer != nil {
                
                let arrayOfCustomer = customer?["data"] as? [String: Any]
                
                if arrayOfCustomer?.count != nil {
                    let keyAbbreviations = arrayOfCustomer?["tenviettat"] as? String
                    let keyUserName = arrayOfCustomer?["tenkh"] as? String
                    let keyTel = arrayOfCustomer?["dienthoai"] as? String
                    let keyMobile = arrayOfCustomer?["didong"] as? String
                    let keyEmail = arrayOfCustomer?["email"] as? String
                    let keyNote = arrayOfCustomer?["ghichu"] as? String
                    let keySkype = arrayOfCustomer?["skype"] as? String
                    let ngaysinh = arrayOfCustomer?["ngaysinh"] as? String
                    let ngaydkkd = arrayOfCustomer?["ngaydkkd"] as? String
                    let keyFacebook = arrayOfCustomer?["facebook"] as? String
                    let manhom = arrayOfCustomer?["manhom"] as? Int
                    let canhan = arrayOfCustomer?["canhan"] as? Bool
                    let manguon = arrayOfCustomer?["manguon"] as? Int
                    let isdaily = arrayOfCustomer?["isdaily"] as? Bool
                    let isemail = arrayOfCustomer?["isemail"] as? Bool
                    let diachi = arrayOfCustomer?["diachi"] as? String
                    let issms = arrayOfCustomer?["issms"] as? Bool
                    let malhc = arrayOfCustomer?["malhc"] as? Int
                    
                    var dateStringNT = String()
                    var dateStringNT1 = String()
                    
                    if ngaysinh != nil {
                        //Convert timerInterver to date
                        let valueNgaytao = ngaysinh ?? ""
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        dateStringNT = dateformat.string(from: dateNT)
                    }
                    
                    if ngaydkkd != nil {
                        //Convert timerInterver to date
                        let valueNgaytao = ngaydkkd ?? ""
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        dateStringNT1 = dateformat.string(from: dateNT)
                    }
                    
                    let textData:  InforCustomer = InforCustomer(abbreviations: keyAbbreviations ?? "", userName: keyUserName ?? "", tel: keyTel ?? "", mobile: keyMobile ?? "", email: keyEmail ?? "", ngaysinh: dateStringNT, ngaydkkd: dateStringNT1 , note: keyNote ?? "", skype: keySkype ?? "", facebook: keyFacebook ?? "", manhom: manhom ?? 0, canhan: canhan!, manguon: manguon ?? 0, isdaily: isdaily!, isemail: isemail!, issms: issms!, malhc: malhc ?? 0, diachi: diachi ?? "")
                    
                    fetchedCustomer.append(textData)
                }
            } else {
                print("api customer nil")
                return
            }
            
            completionHandler(fetchedCustomer)
        }
    }
}

class RequestContactCustomer {
    static func getContactCustomer(parameters: Parameters!, completionHandler: @escaping (([ContactCustomer]) -> ())) {
        APIOnJson(paramer: parameters) { (contact) in
            var fetchedContact = [ContactCustomer]()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            
            let arrayOfCustomer = contact!["data"] as! [String: Any]
            let valueContact = arrayOfCustomer["lienhes"] as! [[String: Any]]
            
            for contact in valueContact {
                let valueMalh = contact["malh"] as? Int
                let valueContactCode = contact["maso"] as? String
                let valueContactEmail = contact["email"] as? String
                let valueContactFullname = contact["hoten"] as? String
                let valueContactPhone = contact["didong"] as? String
                let chucvu = contact["chucvu"] as? String
                let didongkhac = contact["didongkhac"] as? String
                let diachi = contact["diachi"] as? String
                let dienthoai = contact["dienthoai"] as? String
                let ngaysinh = contact["ngaysinh"] as? String
                
                var dateStringNT = String()
                if ngaysinh != nil {
                    let valueNgaytao = ngaysinh ?? ""
                    let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                    let splistNT1 = splistNT[1]
                    let splistNT2 = splistNT1.components(separatedBy: ")/")
                    let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                    dateStringNT = dateformat.string(from: dateNT)
                }
                
                let textData: ContactCustomer = ContactCustomer(maso: valueContactCode ?? "", name: valueContactFullname ?? "", mail: valueContactEmail ?? "", tel: valueContactPhone ?? "", malh: valueMalh ?? 0, chucvu: chucvu ?? "", didongkhac: didongkhac ?? "", diachi: diachi ?? "", dienthoai: dienthoai ?? "", ngaysinh: dateStringNT)
                fetchedContact.append(textData)
            }
             completionHandler(fetchedContact)
        }
    }
}





