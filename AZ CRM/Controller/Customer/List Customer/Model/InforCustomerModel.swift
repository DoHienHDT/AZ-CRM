//
//  InforCustomerModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

class InforCustomer {
    public var abbreviations: String
    public var userName: String
    public var tel: String
    public var mobile: String
    public var email: String
    public var note: String
    public var skype: String
    public var facebook: String
    public var ngaysinh: String
    public var ngaydkkd: String
    public var manhom: Int
    public var canhan: Bool
    public var manguon: Int
    public var isdaily: Bool
    public var isemail: Bool
    public var issms: Bool
    public var malhc: Int
    public var diachi: String
    
    init(abbreviations: String, userName: String, tel: String, mobile: String, email: String,ngaysinh: String,ngaydkkd: String, note: String, skype: String, facebook: String, manhom: Int, canhan: Bool, manguon: Int, isdaily: Bool, isemail: Bool, issms: Bool, malhc: Int, diachi: String) {
        self.abbreviations = abbreviations
        self.userName = userName
        self.tel = tel
        self.mobile = mobile
        self.email = email
        self.note = note
        self.ngaysinh = ngaysinh
        self.skype = skype
        self.facebook = facebook
        self.manhom = manhom
        self.canhan = canhan
        self.manguon = manguon
        self.isdaily = isdaily
        self.isemail = isemail
        self.issms = issms
        self.malhc = malhc
        self.ngaydkkd = ngaydkkd
        self.diachi = diachi
    }
    
}

