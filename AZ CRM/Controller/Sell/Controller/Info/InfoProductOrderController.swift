//
//  InfoProductOrderController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class InfoProductOrderController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var infoOrder = [TakeCareProductModel]()
    var madh: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableView.register(UINib(nibName: "TakeCareOpportProductCell", bundle: nil), forCellReuseIdentifier: "TakeCareOpportProductCell")
        
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method":"order","madh": madh ?? 0, "seckey":urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareProductOpport(parameter: param) { (product) in
                    self.infoOrder = product
                    if self.infoOrder.count != 0 {
                        self.tableView.isHidden = false
                    } else {
                        self.tableView.isHidden = true
                    }
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        Log("has deinitialized")
    }
    
}

extension InfoProductOrderController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakeCareOpportProductCell", for: indexPath) as! TakeCareOpportProductCell
        
        if infoOrder[indexPath.row].tienckSP == 0.0 {
            cell.tienckLabel.text  = "0"
        } else {
            cell.tienckLabel.text = infoOrder[indexPath.row].tienckSP?.description
        }
        
        if infoOrder[indexPath.row].tiengtgtSP == 0.0 {
            cell.tienvatLabel.text  = "0"
        } else {
            cell.tienvatLabel.text = infoOrder[indexPath.row].tiengtgtSP?.description
        }
        
        if infoOrder[indexPath.row].sotienSP == 0.0 {
            cell.tongtienLabel.text  = "0"
        } else {
            cell.tongtienLabel.text = infoOrder[indexPath.row].sotienSP?.description
        }
        
        cell.maspLabel.text = infoOrder[indexPath.row].maspString
        cell.soluongLabel.text = infoOrder[indexPath.row].soluongSP?.description
        cell.thanhtienLabel.text = infoOrder[indexPath.row].thanhtienSP?.description
        cell.dienGiaiLabel.text = infoOrder[indexPath.row].diengiaiSP
        cell.dongiaLabel.text = infoOrder[indexPath.row].dongiaSP?.description
        cell.tenSpLabel.text = infoOrder[indexPath.row].tenspSP
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
}

