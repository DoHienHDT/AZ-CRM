//
//  Alarm.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
class Alarm {
     static var alarm: Alarm = Alarm()
    
     let alarmScheduler: AlarmSchedulerDelegate = Scheduler()
     var alarms: [AlarmItem] = []
    
    func checkAlarm() {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                    let param: Parameters = ["method": "alarm","manv":entity.last!.manv!,"seckey": urlRegister.last!.seckey!]
        
                    Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                        switch response.result {
                        case .success( _):
                            if let valueString =  response.result.value as? [String: Any]  {
                                if let data = valueString["data"] as? [[String:Any]] {
                                    
                                    for valueId in data {
                                        let ngaynhac = valueId["ngaynhac"] as? String
                                        let tieude = valueId["tieude"] as? String
                                        let noidung  = valueId["noidung"] as? String
                                        
                                        if ngaynhac != nil {
                                            let valueNgaytao = ngaynhac!
                                            let splistNT = valueNgaytao.components(separatedBy: "/Date(")
                                            let splistNT1 = splistNT[1]
                                            let splistNT2 = splistNT1.components(separatedBy: ")/")
                                            let dateNT = Date(milliseconds: Int(splistNT2[0]) ?? 0)

                                            let date2 = dateformat.string(from: Date())

                                            if dateNT > dateformat.date(from: date2)! {

                                                let timeInterval = floor(dateNT .timeIntervalSinceReferenceDate / 60.0) * 60.0
                                                let dateString = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
                                                let alarmItem = AlarmItem(date: dateString, title: tieude ?? "", UUID: UUID().uuidString, enabled: true, noidung: noidung ?? "")
                                                print("Add alarm Success ----> \(alarmItem)")
//                                                AlarmList.sharedInstance.changeItem(alarmItem)
                                                AlarmList.sharedInstance.addItem(alarmItem)
                                            }
                                        }
                                    }
                                }
                            }
                        case .failure( _):
                            break
                        }
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopAlarm() {
   
        self.alarms = AlarmList.sharedInstance.allItems()

        for i in 0..<self.alarms.count {
            
            self.alarms[i].enabled = false
            AlarmList.sharedInstance.removeItem(alarms[i])
            AlarmList.sharedInstance.changeItem(self.alarms[i])
            self.alarmScheduler.removeNotification(self.alarms[i])
            print("Remove\(alarms[i])")
        }
    }
}
