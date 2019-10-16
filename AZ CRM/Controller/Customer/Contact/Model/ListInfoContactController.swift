//
//  ListInfoContactController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
class ListInforContactModel {
    
    public var position: String
    public var name: String
    public var tel: String
    public var phone: String
    public var mail: String
    public var note: String
    public var malh: String
    public var manv: Int
    public var makh: Int
    public var diachi: String
    public var ngaysinh: String
 
    init(position: String, name: String, tel: String, phone: String, mail: String, note: String, malh: String, manv: Int, makh: Int, diachi: String,  ngaysinh: String) {
        self.position = position
        self.name = name
        self.tel = tel
        self.phone = phone
        self.mail = mail
        self.note = note
        self.malh = malh
        self.manv = manv
        self.makh = makh
        self.diachi = diachi
        self.ngaysinh = ngaysinh
    }
    
}
