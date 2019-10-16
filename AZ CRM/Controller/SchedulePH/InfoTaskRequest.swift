//
//  InfoTaskRequest.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
import Alamofire
class InfoTaskRequest {
    static func getInfoTask(parameter: Parameters!, completionHandler: @escaping (([InfoTaskModel]) -> ())) {
        APIOnJson(paramer: parameter) { (infoTask) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [InfoTaskModel]()
            if infoTask != nil {
                
                let arrayOfTask = infoTask!["data"] as! [String: Any]
                
                let macv = arrayOfTask["macv"] as? Int
                let tencv = arrayOfTask["tencv"] as? String
                let ngaybd = arrayOfTask["ngaybd"] as? String
                let ngaykt = arrayOfTask["ngaykt"] as? String
                let matt = arrayOfTask["matt"] as? Int
                let makh = arrayOfTask["makh"] as? Int
                let maloai = arrayOfTask["maloai"] as? Int
                let noidung = arrayOfTask["noidung"] as? String
                let mamd = arrayOfTask["mamd"] as? Int
                
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
                
                let api: InfoTaskModel = InfoTaskModel(tencv: tencv ?? "", macv: macv ?? 0, ngaybd: date1, ngaykt: date2, matt: matt ?? 0, makh: makh ?? 0, maloai: maloai ?? 0, noidung: noidung ?? "", mamd: mamd ?? 0)
                fetchedOrder.append(api)
                
            } else {
                print("api customers nil")
                return
            }
            completionHandler(fetchedOrder)
        }
    }
    
    static func getInfoStaffTask(parameter: Parameters!, completionHandler: @escaping (([InfoStaffTaskModel]) -> ())) {
        APIOnJson(paramer: parameter) { (infoTask) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [InfoStaffTaskModel]()
          
            if infoTask != nil {
                
                let arrayOfTask = infoTask!["data"] as! [String: Any]
                let nhanviens = arrayOfTask["nhanviens"] as! [[String: Any]]
                
                for valueStaff in nhanviens {
                    
                    let id = valueStaff["id"] as? Int
                    let manv = valueStaff["manv"] as? Int
                    let macv = valueStaff["macv"] as? Int
                    let diengiai = valueStaff["diengiai"] as? String
                    let mavt = valueStaff["mavt"] as? Int
    
                    
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    let url = NSURL(fileURLWithPath: path)
                    let filePath = url.appendingPathComponent("ApiStaff")?.path
                    let filePath1 = url.appendingPathComponent("ApiTasktitles")?.path
                    var manvString = String()
                    var mavtString = String()
                 
                    if let _ = FileManager.default.contents(atPath: filePath!) {
                        let array = NSArray(contentsOfFile: filePath!)
                        for (_,patientObj) in array!.enumerated() {
                            let patientDict = patientObj as! NSDictionary
                            let patient = Patient(id: patientDict.value(forKey: "id") as? Int, ten: patientDict.value(forKey: "ten") as? String)
                            if manv == patient.id {
                                manvString = patient.ten!
                            }
                        }
                    }
                    
                    if let _ = FileManager.default.contents(atPath: filePath1!) {
                        let array = NSArray(contentsOfFile: filePath1!)
                        for (_,patientObj) in array!.enumerated() {
                            let patientDict = patientObj as! NSDictionary
                            let patient = Patient(id: patientDict.value(forKey: "id") as? Int, ten: patientDict.value(forKey: "ten") as? String)
                            if mavt == patient.id {
                                mavtString = patient.ten!
                              
                            }
                        }
                    }
                    
                    let api: InfoStaffTaskModel = InfoStaffTaskModel(id: id ?? 0,
                                                                     manv:manvString , macv: macv ?? 0 , diengiai: diengiai ?? "",mavt: mavtString , mavtInt: mavt ?? 0, manvInt: manv ?? 0)
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



