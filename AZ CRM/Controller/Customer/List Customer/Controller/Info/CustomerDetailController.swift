//
//  CustomerDetailController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class CustomerDetailController: UIViewController {
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch UIDevice.modelName {
        case "Simulator iPhone X":
             topButton.constant = 30
             heightTitle.constant = 40
        case "iPhone XS":
             topButton.constant = 30
             heightTitle.constant = 40
        case "iPhone XS Max":
             topButton.constant = 30
             heightTitle.constant = 40
        case "iPhone XR":
             topButton.constant = 30
             heightTitle.constant = 40
        default:
            break
        }
    }
    

    @IBAction func backButon(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}


