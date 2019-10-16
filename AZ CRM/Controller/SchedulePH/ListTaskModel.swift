//
//  ListTaskModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

class ListTaskModel {
    
    public var macv: String
    public var tencv: String
    public var ngaybd: String?
    public var ngaykt: String?
    public var tiendo: Int
    public var tenkh: String?
    public var trangthai: String
    public var hoanthanh: Bool
    public var nguoinhap: String
    
    init(macv: String, tencv: String, ngaybd: String? = nil, ngaykt: String? = nil, tiendo: Int, tenkh: String? = nil, trangthai: String, hoanthanh: Bool, nguoinhap: String) {
        self.macv = macv
        self.nguoinhap = nguoinhap
        self.tencv = tencv
        self.hoanthanh = hoanthanh
        self.ngaybd = ngaybd
        self.ngaykt = ngaykt
        self.trangthai = trangthai
        self.tenkh = tenkh
        self.macv = macv
        self.tiendo = tiendo
    }
    
}
