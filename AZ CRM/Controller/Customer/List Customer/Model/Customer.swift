//
//  Customer.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

class Customer{

    var abbreviationName: String
    var company: String
    var mail: String
    var phone: String
    var makh: Int
    
    init(company: String, abbreviationName: String, mail: String, phone: String, makh: Int ) {
        self.company = company
        self.abbreviationName = abbreviationName
        self.mail = mail
        self.phone = phone
        self.makh = makh
    }

}

