//
//  InfoContactController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class InfoContactController: BaseViewController {

    @IBOutlet weak var malhLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var makhLabel: UILabel!
    var malh: Int?
    var makh: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makhLabel.text = makh ?? ""
        navigationView.dropShadow()
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
                
                SVProgressHUD.show()
                let param: Parameters = ["method": "contact","malh":"\(malh!)","seckey": urlRegister.last!.seckey!]
                
                RequestInfoContact.getInfoContact(parameter: param) { [unowned self] (infor) in
                    
                    for value in infor {
                        self.malhLabel.text = value.malh
                        self.positionLabel.text = value.position
                        self.nameLabel.text = value.name
                        self.telLabel.text = value.tel
                        self.phoneLabel.text = value.phone
                        self.emailLabel.text = value.mail
                    }
                    
                    SVProgressHUD.dismiss()
                }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
