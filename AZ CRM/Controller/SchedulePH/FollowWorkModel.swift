//
//  FollowWorkModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

class FollowWorkModel {
    public var ngaynhap: String
    public var noidung: String
    public var tiendo: Int
    public var macv: Int
    public var manvn: Int
    public var ngayxl: String
    public var nguoinhap: String
    
    init(ngaynhap: String, noidung: String, tiendo: Int, macv: Int, manvn: Int, ngayxl: String, nguoinhap: String) {
        self.ngaynhap = ngaynhap
        self.noidung = noidung
        self.tiendo = tiendo
        self.macv = macv
        self.manvn = manvn
        self.ngayxl = ngayxl
        self.nguoinhap = nguoinhap
    }
}
