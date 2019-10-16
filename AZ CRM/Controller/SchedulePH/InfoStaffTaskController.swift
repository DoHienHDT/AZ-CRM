//
//  InfoStaffTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire

class InfoStaffTaskController: UIViewController {
    
    var macv: Int?
    var infoStaffTask = [InfoStaffTaskModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "InfoStaffTaskCell", bundle: nil), forCellReuseIdentifier: "InfoStaffTaskCell")
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["seckey": urlRegister.last!.seckey!, "method": "task","macv":macv!]
                InfoTaskRequest.getInfoStaffTask(parameter: param) { (infoStaffTask) in
                    
                    self.infoStaffTask = infoStaffTask
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

extension InfoStaffTaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoStaffTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoStaffTaskCell", for: indexPath) as! InfoStaffTaskCell
            cell.manvLabel.text = infoStaffTask[indexPath.row].manv
            cell.mavtLabel.text = infoStaffTask[indexPath.row].mavt
            cell.diengiaiLabel.text = infoStaffTask[indexPath.row].diengiai
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    
}
