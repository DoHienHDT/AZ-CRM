//
//  AlarmSchedulerDelegate.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

protocol AlarmSchedulerDelegate {
    func setNotificationWithDate(_ item: AlarmItem)
    func removeNotification(_ item: AlarmItem)
    func scheduleReminder(forItem item: AlarmItem)
    func correctDate(_ date: Date) -> Date
}
