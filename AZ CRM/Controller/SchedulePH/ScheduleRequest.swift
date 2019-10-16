//
//  ScheduleRequest.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Alamofire

class ScheduleRequest  {
    static func getSchedules(parameter: Parameters!, completionHandler: @escaping (([ListScheduleModel]) -> ())) {
        APIOnJson(paramer: parameter) { (schedule) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            var fetchedOrder = [ListScheduleModel]()
            if schedule != nil {
                
                let arrayOfSchedule = schedule!["data"] as! [[String: Any]]
                for valueSchedule in arrayOfSchedule {
                    
                    let malh = valueSchedule["malh"] as? Int
                    let tieude = valueSchedule["tieude"] as? String
                    let ngaybd = valueSchedule["ngaybd"] as? String
                    let ngaykt = valueSchedule["ngaykt"] as? String
                    let diadiem = valueSchedule["diadiem"] as? String
                    let noidung = valueSchedule["noidung"] as? String
                    let nhanvien = valueSchedule["nhanvien"] as? String
                    
                    var dateStringNT = String()
                    
                    if ngaybd != nil {
                        //Convert timerInterver to date
                        let valueNgaytao = ngaybd ?? ""
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        dateStringNT = dateformat.string(from: dateNT)
                    }
                    
                    var dateStringNT1 = String()
                    if ngaykt != nil {
                        //Convert timerInterver to date
                        let valueNgaytao1 = ngaykt ?? ""
                        let splistNT3 = valueNgaytao1.components(separatedBy: "/Date(")
                        let splistNT4 = splistNT3[1]
                        let splistNT5 = splistNT4.components(separatedBy: ")/")
                        let dateNT1 = Date(milliseconds: Int(splistNT5[0]) ?? 0)
                        dateStringNT1 = dateformat.string(from: dateNT1)
                    }
                    
                    let api: ListScheduleModel = ListScheduleModel(malh: malh ?? 0, tieude: tieude ?? "", ngaybd: dateStringNT , ngaykt: dateStringNT1 , diadiem: diadiem ?? "", noidung: noidung ?? "", nhanvien: nhanvien ?? "")
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

class InfoScheduleRequest {
    static func getInfoSchedules(parameter: Parameters!, completionHandler: @escaping (([InfoScheduleModel]) -> ())) {
        APIOnJson(paramer: parameter) { (schedule) in
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy hh:mm:ss"
            
            let dateformat1 = DateFormatter()
            dateformat1.dateFormat = "mm"
        
            var fetchedOrder = [InfoScheduleModel]()
            if schedule != nil {
                
                    let arrayOfSchedule = schedule!["data"] as! [String: Any]
                    let tieude = arrayOfSchedule["tieude"] as? String
                    let diadiem = arrayOfSchedule["diadiem"] as? String
                    let noidung = arrayOfSchedule["noidung"] as? String
                    let ngaybd = arrayOfSchedule["ngaybd"] as? String
                    let ngaykt = arrayOfSchedule["ngaykt"] as? String
                    let ngaynhac = arrayOfSchedule["ngaynhac"] as? String
                    let malh = arrayOfSchedule["malh"] as? Int
                    let matd = arrayOfSchedule["matd"] as? Int
                    let makh = arrayOfSchedule["makh"] as? Int
                    let macv = arrayOfSchedule["macv"] as? Int
                    let manvhts = arrayOfSchedule["manvhts"] as? [Int]
                    var date1 = String()
                    var date2 = String()
                    var date3 = Int()
                    var date4 = String()
                
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
                    
                    if ngaynhac != nil, ngaybd != nil {
                        
                        let valueNgaytao = ngaybd!
                        let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                        let splistNT1 = splistNT[1]
                        let splistNT2 = splistNT1.components(separatedBy: ")/")
                        let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)
                        let caculator = dateformat.string(from: dateNT)
                 
                        let valueNhac = ngaynhac!
                        let splistNN = valueNhac.components(separatedBy: "/Date(")
                        let splistNN1 = splistNN[1]
                        let splistNN2 = splistNN1.components(separatedBy: ")/")
                        let dateNN = Date(milliseconds: Int(splistNN2[0]) ?? 0)
                        date4 = dateformat.string(from: dateNN)
                 
                        date3 = interval(start: caculator, end: date4)
                        
                    }
                    
                let api: InfoScheduleModel = InfoScheduleModel(tieude: tieude, diadiem: diadiem,nhactruoc: date3.description, noidung: noidung, ngaybd: date1, ngaykt: date2, ngaynhac: date4, malh: malh?.description, matd: matd?.description, makh: makh ?? 0, macv: macv?.description, manvhts: manvhts)
                    fetchedOrder.append(api)
            } else {
                print("api customers nil")
                return
            }
            completionHandler(fetchedOrder)
        }
        
       
        }
    }
func interval(start: String, end: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
    let date = dateFormatter.date(from:start)!
    let date1 = dateFormatter.date(from:end)!
    
    let currentCalendar = Calendar.current
    guard let start = currentCalendar.ordinality(of: .minute, in: .era, for: date) else { return 0 }
    guard let end = currentCalendar.ordinality(of: .minute, in: .era, for: date1) else { return 0 }
    print(start - end)
    return start - end
}
