//
//  AlarmItem.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
struct AlarmItem {
    var title: String
    var date: Date
    var snoozeEnabled: Bool = false
    var enabled: Bool = false
    var noidung: String
    var UUID: String
    
    init(date: Date, title: String, UUID: String, enabled: Bool, noidung: String) {
        self.date = date
        self.title = title
        self.UUID = UUID
        self.enabled = enabled
        self.noidung = noidung
    }
    
    var isOverdue: Bool {
        return (Date().compare(self.date) == ComparisonResult.orderedDescending)
    }
}
