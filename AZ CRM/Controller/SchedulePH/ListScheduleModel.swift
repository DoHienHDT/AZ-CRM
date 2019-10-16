//
//  ListScheduleModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Alamofire

class ListScheduleModel {
    public var malh: Int
    public var tieude: String
    public var ngaybd: String
    public var ngaykt: String
    public var diadiem: String
    public var noidung: String
    public var nhanvien: String
    
    init(malh: Int, tieude: String, ngaybd: String, ngaykt: String, diadiem: String, noidung: String, nhanvien: String) {
        self.malh = malh
        self.tieude = tieude
        self.ngaybd = ngaybd
        self.ngaykt = ngaykt
        self.diadiem = diadiem
        self.noidung = noidung
        self.nhanvien = nhanvien
    }
}

class InfoScheduleModel {
    
    public var tieude: String?
    public var diadiem: String?
    public var noidung: String?
    public var ngaybd: String?
    public var ngaykt: String?
    public var ngaynhac: String?
    public var nhactruoc: String?
    public var malh: String?
    public var matd: String?
    public var makh: Int?
    public var macv: String?
    public var manvhts: [Int]?
    
    init(tieude: String? = nil, diadiem: String? = nil,nhactruoc: String? = nil, noidung: String? = nil, ngaybd: String? = nil, ngaykt: String? = nil, ngaynhac: String? = nil, malh: String? = nil, matd: String? = nil, makh: Int? = nil, macv: String? = nil, manvhts: [Int]? = nil) {
        self.tieude = tieude
        self.diadiem = diadiem
        self.noidung = noidung
        self.ngaybd = ngaybd
        self.ngaykt = ngaykt
        self.ngaynhac = ngaynhac
        self.malh = malh
        self.matd = matd
        self.makh = makh
        self.macv = macv
        self.manvhts = manvhts
        self.nhactruoc = nhactruoc
    }
    
}

