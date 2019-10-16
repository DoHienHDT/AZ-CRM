//
//  TakeCareOpportProductDetailController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class TakeCareOpportProductDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var mancOpport: Int?
    var takeCare = [TakeCareProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiOportProcess()
        tableView.register(UINib(nibName: "TakeCareOpportProductCell", bundle: nil), forCellReuseIdentifier: "TakeCareOpportProductCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takeCare.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakeCareOpportProductCell", for: indexPath) as! TakeCareOpportProductCell
        
            cell.maspLabel.text = takeCare[indexPath.row].maspString
        
            if takeCare[indexPath.row].tienckSP == 0.0 {
                cell.tienckLabel.text  = "0"
            } else {
                cell.tienckLabel.text = takeCare[indexPath.row].tienckSP?.description
            }
        
            if takeCare[indexPath.row].tiengtgtSP == 0.0 {
                cell.tienvatLabel.text  = "0"
            } else {
                cell.tienvatLabel.text = takeCare[indexPath.row].tiengtgtSP?.description
            }
        
            if takeCare[indexPath.row].sotienSP == 0.0 {
                cell.tongtienLabel.text  = "0"
            } else {
                cell.tongtienLabel.text = takeCare[indexPath.row].sotienSP?.description
            }
        
            cell.soluongLabel.text = takeCare[indexPath.row].soluongSP?.description
            cell.thanhtienLabel.text = takeCare[indexPath.row].thanhtienSP?.description
            cell.dienGiaiLabel.text = takeCare[indexPath.row].diengiaiSP
            cell.dongiaLabel.text = takeCare[indexPath.row].dongiaSP?.description
            cell.tenSpLabel.text = takeCare[indexPath.row].tenspSP
            cell.heightDGLabel.text = "Diễn giải"
        
        return cell
    }
    
    func apiOportProcess() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunity","manc": mancOpport!,"seckey": urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareProductOpport(parameter: param) { [unowned self] (takeCare) in
                    self.takeCare = takeCare
                    if takeCare.count != 0 {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }

}
