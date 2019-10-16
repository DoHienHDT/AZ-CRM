//
//  RequestTakeCareOpport.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class  RequestTakeCareOpport {
    
    static func getTakeCareProductOpport(parameter: Parameters!, completionHandler: @escaping (([TakeCareProductModel]) -> ())) {
        APIOnJson(paramer: parameter) { (opport) in
            var fetchedOpport = [TakeCareProductModel]()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            
            if opport != nil {
                 let arrayOfCustomer = opport!["data"] as! [String: Any]
             
                    let sanphams = arrayOfCustomer["sanphams"] as! [[String: Any]]
                    for valueSP in sanphams {
                        
                        let id = valueSP["id"] as? Int
                        let masp = valueSP["masp"] as? Int
                        let madvt = valueSP["madvt"] as? Int
                        let dongia = valueSP["dongia"] as? Double
                        let soluong = valueSP["soluong"] as? Int
                        let thuegtgt = valueSP["thuegtgt"] as? Double
                        let tiengtgt = valueSP["tiengtgt"] as? Double
                        let tyleck = valueSP["tyleck"] as? Double
                        let tienck = valueSP["tienck"] as? Double
                        let diengiaiSP = valueSP["diengiai"] as? String
                        let sotien = valueSP["sotien"] as? Double
                        let thanhtien = valueSP["thanhtien"] as? Double
                        let tendvt = valueSP["tendvt"] as? String
                        let tensp = valueSP["tensp"] as? String
                        let ngaydh = valueSP["ngaydh"] as? String
                        
                        var dateStringNTSP = String()
                        
                        if ngaydh != nil {
                            //Convert timerInterver to date
                            let valueNgaytao = ngaydh ?? ""
                            let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                            let splistNT1 = splistNT[1]
                            let splistNT2 = splistNT1.components(separatedBy: ")/")
                            let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                            dateStringNTSP = dateformat.string(from: dateNT)
                        }
                        
                        var maspString = String()
                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                        let url = NSURL(fileURLWithPath: path)
                        let filePath = url.appendingPathComponent("ApiProduct")?.path
                        
                        if let _ = FileManager.default.contents(atPath: filePath!) {
                            let array = NSArray(contentsOfFile: filePath!)
                            for (_,patientObj) in array!.enumerated() {
                                let patientDict = patientObj as! NSDictionary
                                let patient = Patient(id: patientDict.value(forKey: "id") as? Int, ten: patientDict.value(forKey: "ten") as? String)
                                if masp == patient.id {
                                    maspString = patient.ten!
                                }
                            }
                        }
                        
                        let textData: TakeCareProductModel = TakeCareProductModel(id: id, maspSP: masp, maspString: maspString, madvtSP: madvt, dongiaSP: dongia, soluongSP: soluong, thuegtgtSP: thuegtgt, tiengtgtSP: tiengtgt, tyleckSP: tyleck, tienckSP: tienck, diengiaiSP: diengiaiSP, sotienSP: sotien, thanhtienSP: thanhtien, tendvtSP: tendvt, tenspSP: tensp, ngaydhSP: dateStringNTSP)
                        fetchedOpport.append(textData)
                }
            }
            completionHandler(fetchedOpport)
        }
    }
    
    static func getTakeCareOport(parameter: Parameters!, completionHandler: @escaping (([TakeCareOpportModel]) -> ())) {
        APIOnJson(paramer: parameter) { (oport) in
            
            var fetchedOpport = [TakeCareOpportModel]()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            
            if oport != nil {
                let arrayOfCustomer = oport!["data"] as! [String: Any]
                    let mancOpport = arrayOfCustomer["manc"] as? Int
                    let dateOpport = arrayOfCustomer["ngaytao"] as? String
                    let masoOpport = arrayOfCustomer["maso"] as? String
                    let mattOpport = arrayOfCustomer["matt"] as? Int
                    let valueOpport = arrayOfCustomer["giatri"] as? Int
                    let tiemnangOpport = arrayOfCustomer["tiemnang"] as? Int
                    let manvhts = arrayOfCustomer["manvhts"] as? [String]
                
                    let diengiai = arrayOfCustomer["diengiai"] as? String
                    let makh = arrayOfCustomer["makh"] as? Int
                    var dateStringNT = String()

                    if dateOpport != nil {
                        //Convert timerInterver to date
                        let valueNgaytao = dateOpport ?? ""
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        dateStringNT = dateformat.string(from: dateNT)
                    }
                
                if manvhts?.count != 0 {
                    let textData: TakeCareOpportModel = TakeCareOpportModel(manc: mancOpport ?? 0, ngaytao: dateStringNT, maso: masoOpport ?? "", matt: mattOpport ?? 0, giatri: valueOpport ?? 0, diengiai: diengiai ?? "", tiemnang: tiemnangOpport ?? 0, makh: makh, manvhts: manvhts)
                       fetchedOpport.append(textData)
                } else {
                     let textData: TakeCareOpportModel = TakeCareOpportModel(manc: mancOpport ?? 0, ngaytao: dateStringNT, maso: masoOpport ?? "", matt: mattOpport ?? 0, giatri: valueOpport ?? 0, diengiai: diengiai ?? "", tiemnang: tiemnangOpport ?? 0, makh: makh)
                    fetchedOpport.append(textData)
                }
    
            } else {
                print("api opportunities nil")
                return
            }
            
            completionHandler(fetchedOpport)
        }
    }
}

