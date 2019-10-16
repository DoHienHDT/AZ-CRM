//
//  InfoTaskModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation

class InfoTaskModel {
    public var tencv: String
    public var macv: Int
    public var ngaybd: String
    public var ngaykt: String
    public var matt: Int
    public var makh: Int
    public var maloai: Int
    public var noidung: String
    public var mamd: Int
    
    init(tencv: String, macv: Int, ngaybd: String, ngaykt: String, matt: Int, makh: Int, maloai: Int, noidung: String, mamd: Int) {
        self.tencv = tencv
        self.macv = macv
        self.ngaybd = ngaybd
        self.ngaykt = ngaykt
        self.matt = matt
        self.makh = makh
        self.maloai = maloai
        self.noidung = noidung
        self.mamd = mamd
    }
}

class InfoStaffTaskModel {
    public var id: Int
    public var manv: String?
    public var macv: Int
    public var diengiai: String
    public var mavt: String?
    public var mavtInt: Int
    public var manvInt: Int
   
    init(id: Int, manv: String? = nil, macv: Int, diengiai: String, mavt: String? = nil, mavtInt: Int, manvInt: Int) {
        self.id = id
        self.manv = manv
        self.macv = macv
        self.diengiai = diengiai
        self.mavt = mavt
        self.mavtInt = mavtInt
        self.manvInt = manvInt
    }
}


