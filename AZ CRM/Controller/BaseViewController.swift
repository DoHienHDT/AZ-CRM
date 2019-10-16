//
//  BaseViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        // Do any additional setup after loading the view.
    }
}
