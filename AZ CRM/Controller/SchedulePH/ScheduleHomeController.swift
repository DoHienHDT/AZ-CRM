//
//  ScheduleHomeController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit

class ScheduleHomeController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    let data = ["Công việc","Lịch hẹn"]
    let image = ["cong_viec", "lich_hen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        navigationView.dropShadow()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        // Do any additional setup after loading the view.
    }
    
}

extension ScheduleHomeController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.taskName.text = data[indexPath.row]
        cell.imageView?.image = UIImage(named: image[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if entity.last?.quyenCV != nil {
                        self.performSegue(withIdentifier: "PlanIdSegue", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Bạn không có quyền truy cập", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok")
                        present(alert, animated: true, completion: nil)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
           
        case 1:
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if entity.last?.quyenLHen != nil {
                          self.performSegue(withIdentifier: "schedule", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Bạn không có quyền truy cập", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok")
                        present(alert, animated: true, completion: nil)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        default:
            print("")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
