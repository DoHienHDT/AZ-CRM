//
//  InfoCustomerController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD

class InfoCustomerController: BaseViewController {
    
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dienthoaiLabel: UILabel!
    @IBOutlet weak var didongLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var skypeLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var nhomKhLabel: UILabel!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var diachiLabel: UILabel!
    
    var makh: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requetsInfor()
    }

    func requetsInfor() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                SVProgressHUD.show()
                let param: Parameters = ["method": "customer", "makh": makh ?? "","seckey": urlRegister.last!.seckey!]
                RequestInfoCustomer.getInforCustomer(parameter: param) { (infor) in
                    
                    for inforCustomer in infor {
                        self.makhLabel.text = inforCustomer.abbreviations
                        self.nameLabel.text = inforCustomer.userName
                        self.dienthoaiLabel.text = inforCustomer.tel
                        self.didongLabel.text = inforCustomer.mobile
                        self.mailLabel.text = inforCustomer.email
                        self.skypeLabel.text = inforCustomer.skype
                        self.facebookLabel.text = inforCustomer.facebook
                        self.noteLabel.text = inforCustomer.note
                        self.diachiLabel.text = inforCustomer.diachi
                        self.smsButton.isSelected = inforCustomer.issms
                        self.mailButton.isSelected = inforCustomer.isemail
                        self.dailyButton.isSelected = inforCustomer.isdaily
                        if inforCustomer.manhom != 0 {
                            let param: Parameters = ["method": "customergroups","seckey": urlRegister.last!.seckey!]
                            RequestGroups.getManhom(parameters: param, completionHandler: { (manhomValue) in
                                for value in manhomValue {
                                    if inforCustomer.manhom == Int(value.manhom[0]) {
                                        self.nhomKhLabel.text = value.manhom[1]
                                    }
                                }
                            })
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

