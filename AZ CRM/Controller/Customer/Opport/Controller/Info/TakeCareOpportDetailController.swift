//
//  TakeCareOpportDetailController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD

class TakeCareOpportDetailController: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var mancOpport: Int?
    var takeCare = [TakeCareOpportModel]()
    var index: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TakeCareOportCell", bundle: nil), forCellReuseIdentifier: "TakeCareOportCell")
        tableView.isHidden = true
        apiOportProcess()
    }
    
    @IBAction func nhatkyButton(_ sender: Any) {
   
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takeCare.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expandableCell = tableView.dequeueReusableCell(withIdentifier: "TakeCareOportCell") as! TakeCareOportCell
        expandableCell.masoLabel.text = takeCare[indexPath.row].maso
        expandableCell.ngaytaoLabel.text = takeCare[indexPath.row].ngaytao
        expandableCell.tiemnangLabel.text = String(takeCare[indexPath.row].tiemnang)
        expandableCell.dienGiaiTextView.text = takeCare[indexPath.row].diengiai
        
        return expandableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if takeCare[indexPath.row].diengiai != "" {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let text: [AttributedTextBlock] = [
                .normal(""),
                .header1("Nội dung:"),
                .normal("\(takeCare[indexPath.row].diengiai)")]
            alert.addTextViewer(text: .attributedText(text))
            alert.addAction(title: "OK",color: .red, style: .cancel)
            alert.show()
        }
    }
    
    func apiOportProcess() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunity","manc":mancOpport!,"seckey": urlRegister.last!.seckey!]
                RequestTakeCareOpport.getTakeCareOport(parameter: param) { [unowned self] (takeCare) in
                    self.takeCare = takeCare
                    print(takeCare.count)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
