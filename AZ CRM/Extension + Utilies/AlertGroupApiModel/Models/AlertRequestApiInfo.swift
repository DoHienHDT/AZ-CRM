//
//  AlertRequestApiInfo.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import Foundation
import  UIKit

public class AlertRequestApiInfo {
    
    public var dvtProduct: [String]?
    public var product: [String]
    public var customer: [String]
    public var opportunitystatus: [String]
    public var staff: [String]
    public var customerGroups: [String]
    public var customersources: [String]
    public var orderstatus: [String]
    public var orderpaymentmethods: [String]
    public var ordertransportmethods: [String]
    public var moneytypes: [String]
    public var opportunitymeettypes: [String]
    public var tasktypes: [String]
    public var taskprios: [String]
    public var taskstatus: [String]
    public var tasktitles: [String]
    public var companies: [String]
    public var tasks: [String]
    
    init(dvtProduct: [String]? = nil, product: [String]? = nil, customer: [String]? = nil, opportunitystatus: [String]? = nil, staff: [String]? = nil, customerGroups: [String]? = nil, customersources: [String]? = nil, orderstatus: [String]? = nil,orderpaymentmethods: [String]? = nil, ordertransportmethods: [String]? = nil, moneytypes: [String]? = nil, opportunitymeettypes: [String]? = nil, tasktypes: [String]? = nil, taskprios: [String]? = nil, taskstatus: [String]? = nil, tasktitles: [String]? = nil, companies: [String]? = nil, tasks: [String]? = nil) {
        self.dvtProduct = dvtProduct
        self.product = product ?? [""]
        self.customer = customer ?? [""]
        self.opportunitystatus = opportunitystatus ?? [""]
        self.staff = staff ?? [""]
        self.customerGroups = customerGroups ?? [""]
        self.customersources = customersources ?? [""]
        self.orderstatus = orderstatus ?? [""]
        self.orderpaymentmethods = orderpaymentmethods ?? [""]
        self.ordertransportmethods = ordertransportmethods ?? [""]
        self.moneytypes = moneytypes ?? [""]
        self.opportunitymeettypes = opportunitymeettypes ?? [""]
        self.tasktypes = tasktypes ?? [""]
        self.taskprios = taskprios ?? [""]
        self.taskstatus = taskstatus ?? [""]
        self.tasktitles = tasktitles ?? [""]
        self.companies = companies ?? [""]
        self.tasks = tasks ?? [""]
    }
}
