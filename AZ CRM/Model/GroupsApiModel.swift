//
//  GroupsApiModel.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import RSSelectionMenu

class Manhom {
    public var manhom: [String]
    
    init(manhom: [String]) {
        self.manhom = manhom
    }
}

class Manguon {
    public var manguon: [String]
    
    init(manguon: [String]) {
        self.manguon = manguon
    }
}

class MaSP {
    public var masp: [String]
    
    init(masp: [String]) {
        self.masp = masp
    }
}

class MaDvtSP {
    public var maDvtSp: [String]
    
    init(maDvtSp: [String]) {
        self.maDvtSp = maDvtSp
    }
}

class Staff: NSObject, UniquePropertyDelegate {
    var maso: String
    var manv: Int
    var hoten: String
    
    init(maso: String, manv: Int, hoten: String) {
        self.maso = maso
        self.manv = manv
        self.hoten = hoten
    }
    
    // MARK: - UniquePropertyDelegate
    func getUniquePropertyName() -> String {
        return "maso"
    }
}

class CustomerMaKH {
    public var makh: [String]
    init(makh: [String]) {
        self.makh = makh
    }
}

class OpportunityStatus {
    public var status: [String]
    init(status: [String]) {
        self.status = status
    }
}
