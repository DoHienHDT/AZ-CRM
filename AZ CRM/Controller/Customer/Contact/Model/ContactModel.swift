//
//  ContactModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class ContactModel {

    public var company: String
    public var mail: String
    public var phone: String
    public var maso: String
    public var malh: Int
    public var tenkh: String
    public var makh: Int
    
    init(company: String, mail: String, phone: String, maso: String, malh: Int, tenkh: String, makh: Int) {
        self.tenkh = tenkh
        self.company = company
        self.mail = mail
        self.phone = phone
        self.maso = maso
        self.malh = malh
        self.makh = makh
    }
}
