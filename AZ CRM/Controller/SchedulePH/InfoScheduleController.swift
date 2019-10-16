//
//  InfoScheduleController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class InfoScheduleController: BaseViewController {

    var malh: Int?
    var infoList = [InfoScheduleModel]()
    
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var tieudeLabel: UILabel!
    @IBOutlet weak var makhLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mandLabel: UILabel!
    @IBOutlet weak var ngaynhacLabel: UILabel!
    @IBOutlet weak var manvhtsLabel: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method":"schedue","malh":malh!, "seckey":urlRegister.last!.seckey!]
                InfoScheduleRequest.getInfoSchedules(parameter: param) { [unowned self] (info) in
                    for value in info {
                        self.ngaybdLabel.text = value.ngaybd
                        self.ngayktLabel.text = value.ngaykt
                        self.ngaynhacLabel.text = value.ngaynhac
                        self.tieudeLabel.text = value.tieude
                        self.mandLabel.text = value.noidung
                        self.addressLabel.text = value.diadiem
                        
                        // get id makh add string Label
                        if value.makh != 0 {
                            let paramMakh: Parameters = ["method": "customer", "makh": value.makh!,"seckey": urlRegister.last!.seckey!]
                            RequestInfoCustomer.getInforCustomer(parameter: paramMakh) { (inforMakh) in
                                if inforMakh.count != 0 {
                                    
                                }
                                for value in inforMakh {
                                    self.makhLabel.text = value.userName
                                }
                            }
                        }
                        var arrayString = [String]()
                        if value.manvhts?.count != 0 {
                            for value in value.manvhts! {
                                let param: Parameters = ["method": "staffs","seckey": urlRegister.last!.seckey!]
                                AlertRequestApi.getInfo(param: param, type: .staff) { [unowned self] (info) in
                                    for valueId in info {
                                        if value == Int(valueId.staff[0]) {
                                            arrayString.append(valueId.staff[1])
                                            self.manvhtsLabel.text = arrayString.joined(separator: ", ")
                                        }
                                    }
                                }
                            }
                        }
                        //End
                        
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

