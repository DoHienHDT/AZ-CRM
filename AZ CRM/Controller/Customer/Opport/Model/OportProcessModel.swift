//
//  OportProcessModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

class OportProcessModel {
    
    var noidung: String
    var hinhthuc: String
    var ngayxl: String
    var ngaytao: String
    var nguoitao: String
    var nguoiquanly: String
    
    init(noidung: String, hinhthuc: String, ngayxl: String,ngaytao: String, nguoitao: String, nguoiquanly: String ) {
        self.noidung = noidung
        self.hinhthuc = hinhthuc
        self.ngayxl = ngayxl
        self.ngaytao = ngaytao
        self.nguoitao = nguoitao
        self.nguoiquanly = nguoiquanly
    }
}
