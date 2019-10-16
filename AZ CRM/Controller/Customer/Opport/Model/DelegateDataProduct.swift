//
//  DelegateDataProduct.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import Foundation
class DelegateDataProduct {
    public var productLabel: String
    public var dvtLabel: String
    public var soluongTextField: String
    public var dongiaTextField: String
    public var thanhtienLabel: String
    public var tyleCkTextField: String
    public var tienCKTextField: String
    public var vatTextField: String
    public var tienVatTextField: String
    public var tongTienTextField: String
    public var masp: Int
    public var madvt: Int
    public var ngaydh: String
    public var diengiai: String
    
    init(productLabel: String, dvtLabel: String , soluongTextField: String, dongiaTextField: String, thanhtienLabel: String, tyleCkTextField: String, tienCKTextField: String, vatTextField: String, tienVatTextField: String, tongTienTextField: String, masp: Int, madvt: Int, ngaydh: String, diengiai: String) {
        self.productLabel = productLabel
        self.dvtLabel = dvtLabel
        self.soluongTextField = soluongTextField
        self.dongiaTextField = dongiaTextField
        self.thanhtienLabel = thanhtienLabel
        self.tyleCkTextField = tyleCkTextField
        self.tienCKTextField = tienCKTextField
        self.vatTextField = vatTextField
        self.tienVatTextField = tienVatTextField
        self.tongTienTextField = tongTienTextField
        self.masp = masp
        self.madvt = madvt
        self.ngaydh = ngaydh
        self.diengiai = diengiai
    }
}

class DelegateStaff {
    public var vitri: String
    public var nhanvien: String
    public var diengiai: String
    public var mavt: Int
    public var manv: Int
    
    init(vitri: String, nhanvien: String, diengiai: String, mavt: Int, manv: Int) {
        self.vitri = vitri
        self.nhanvien = nhanvien
        self.diengiai = diengiai
        self.mavt = mavt
        self.manv = manv
    }
    
}
