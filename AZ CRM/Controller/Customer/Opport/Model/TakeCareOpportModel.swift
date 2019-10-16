//
//  TakeCareOpportModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation

class TakeCareProductModel {
    
    public var id: Int?
    public var maspSP: Int?
    public var maspString: String?
    public var madvtSP: Int?
    public var dongiaSP: Double?
    public var soluongSP: Int?
    public var thuegtgtSP: Double?
    public var tiengtgtSP: Double?
    public var tyleckSP: Double?
    public var tienckSP: Double?
    public var diengiaiSP: String?
    public var sotienSP: Double?
    public var thanhtienSP: Double?
    public var tendvtSP: String?
    public var tenspSP: String?
    public var ngaydhSP: String?
    
    init(id: Int?, maspSP: Int? = nil,maspString: String, madvtSP: Int? = nil, dongiaSP: Double? = nil, soluongSP: Int? = nil, thuegtgtSP: Double? = nil, tiengtgtSP: Double? = nil, tyleckSP: Double? = nil, tienckSP: Double? = nil, diengiaiSP: String? = nil, sotienSP: Double? = nil, thanhtienSP: Double? = nil, tendvtSP: String? = nil, tenspSP: String? = nil, ngaydhSP: String? = nil) {
        self.id = id
        self.maspString = maspString
        self.maspSP = maspSP
        self.madvtSP = madvtSP
        self.dongiaSP = dongiaSP
        self.soluongSP = soluongSP
        self.thuegtgtSP = thuegtgtSP
        self.tiengtgtSP = tiengtgtSP
        self.tyleckSP = tyleckSP
        self.tienckSP = tienckSP
        self.diengiaiSP = diengiaiSP
        self.sotienSP = sotienSP
        self.thanhtienSP = thanhtienSP
        self.tendvtSP = tendvtSP
        self.tenspSP = tenspSP
        self.ngaydhSP = ngaydhSP
    }
    
}

class TakeCareOpportModel {
    public var manc: Int
    public var ngaytao: String
    public var maso: String
    public var matt: Int
    public var giatri: Int
    public var diengiai: String
    public var tiemnang: Int
    public var makh: Int?
    public var manvhts: [String]?
    init(manc: Int, ngaytao: String, maso: String, matt: Int, giatri: Int, diengiai: String, tiemnang: Int, makh: Int? = nil, manvhts: [String]? = nil) {
        self.manc = manc
        self.manvhts = manvhts
        self.ngaytao = ngaytao
        self.maso = maso
        self.matt = matt
        self.giatri = giatri
        self.diengiai = diengiai
        self.tiemnang = tiemnang
        self.makh = makh
    }
}
