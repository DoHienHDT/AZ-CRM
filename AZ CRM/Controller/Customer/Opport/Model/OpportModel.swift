//
//  OpportModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class OpportModel {
  
    var mancOpport: Int
    var dateOpport: String
    var masoOpport: String
    var nameOpport: String
    var valueOpport: Double
    var potentialOpport: Int
    var telOpport: String
    var emailOpport: String
    var makh: Int
    
    init(mancOpport: Int, dateOpport: String,masoOpport: String, nameOpport: String, valueOpport: Double, potentialOpport: Int, telOpport: String, emailOpport: String, makh: Int) {
        self.mancOpport = mancOpport
        self.dateOpport = dateOpport
        self.masoOpport = masoOpport
        self.nameOpport = nameOpport
        self.valueOpport = valueOpport
        self.potentialOpport = potentialOpport
        self.telOpport = telOpport
        self.emailOpport = emailOpport
        self.makh = makh
    }
    
}
