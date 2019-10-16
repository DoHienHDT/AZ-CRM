//
//  ContactCustomer.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

class ContactCustomer {
    
    public var maso: String
    public var name: String
    public var mail: String
    public var tel: String
    public var malh: Int
    public var chucvu: String
    public var didongkhac: String
    public var diachi: String
    public var dienthoai: String
    public var ngaysinh: String
    
    init(maso: String, name: String, mail: String, tel: String, malh: Int, chucvu: String, didongkhac: String, diachi: String, dienthoai: String, ngaysinh: String) {
        self.maso = maso
        self.name = name
        self.mail = mail
        self.tel = tel
        self.malh = malh
        self.chucvu = chucvu
        self.didongkhac = didongkhac
        self.diachi = diachi
        self.dienthoai = dienthoai
        self.ngaysinh = ngaysinh
    }
}

