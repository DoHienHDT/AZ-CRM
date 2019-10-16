//
//  CustomerViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class CustomerViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate {
    
    let data  = ["Khách hàng","Liên hệ", "Cơ hội"]
    let image = ["khach_hang","lien_he","co_hoi"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    
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
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            cell.taskName.text = data[indexPath.row]
            cell.imageView?.image = UIImage(named: image[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if entity.last?.quyenKH != nil {
                        self.performSegue(withIdentifier: "Customer0", sender: self)
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
                    if entity.last?.quyenLH != nil {
                        self.performSegue(withIdentifier: "Customer1", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Bạn không có quyền truy cập", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok")
                        present(alert, animated: true, completion: nil)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        case 2:
            do {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if entity.last?.quyenCH != nil {
                        self.performSegue(withIdentifier: "Customer2", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Bạn không có quyền truy cập", message: nil, preferredStyle: .alert)
                        alert.addAction(title: "Ok")
                        present(alert, animated: true, completion: nil)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
//
//        case 3:
//            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
//            alert.addAction(title: "Ok", style: .cancel)
//            present(alert, animated: true, completion: nil)
//        case 4:
//            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
//            alert.addAction(title: "Ok", style: .cancel)
//            present(alert, animated: true, completion: nil)
        default:
            print("")
        }
    }
    
    @IBAction func unwindCustomer(for unwindSegue: UIStoryboardSegue) {
    }
    
}
