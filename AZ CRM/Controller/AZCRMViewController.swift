//
//  AZCRMViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class AZCRMViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var dangxuatBt: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightLabel: NSLayoutConstraint!
    
    var content = ["Khách hàng","Bán hàng","Công việc"]
    var icon = ["khach_hang","ban_hang","cong_viec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            Alarm.alarm.checkAlarm()
        }

        navigationView.dropShadow()
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        self.dangxuatBt.layer.cornerRadius = 30
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.catchIt), name: NSNotification.Name(rawValue: "myNotif"), object: nil)
        
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightLabel.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
//    @objc func catchIt(_ userInfo: Notification){
//
//        let prefs: UserDefaults = UserDefaults.standard
//        prefs.removeObject(forKey: "startUpNotif")
//
//        if userInfo.userInfo?["userInfo"] != nil{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc: AZCRMViewController = storyboard.instantiateViewController(withIdentifier: "AZCRMViewController") as! AZCRMViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc: DemoViewController = storyboard.instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.taskName.text = content[indexPath.row]
        cell.imageView?.image = UIImage(named: String(icon[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch content[indexPath.row] {
        case "Khách hàng":
            self.performSegue(withIdentifier: "CustomerIdSegue", sender: self)
        case "Sản phẩm":
            //            self.performSegue(withIdentifier: "SellIdSegue", sender: self)
            //            print("hi")vm6
            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        case "Bán hàng":
            self.performSegue(withIdentifier: "SellIdSegue", sender: self)
            //            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
            //            let openAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            //            alert.addAction(openAction)
            //            present(alert, animated: true, completion: nil)
        case "Công việc":
            self.performSegue(withIdentifier: "ScheduleSegue", sender: self)
            //            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
            //            let openAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            //            alert.addAction(openAction)
            //            present(alert, animated: true, completion: nil)
        case "Chính sách":
            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
            
        case "Kho hàng":
            let alert = UIAlertController(title: "Chức năng đang nâng cấp", message: nil, preferredStyle: .alert)
            let openAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func unwindHome(for unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func logoutButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn thoát khỏi phiên đăng nhập này không?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Không", style: .cancel, handler: nil)
        let action1 = UIAlertAction(title: "Đồng ý", style: .default) { (_) in
            Alarm.alarm.stopAlarm()
            self.logout()
            removeUserDefaults()
        }
        
        action.setValue(UIColor.red, forKey: "titleTextColor")
        action1.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(action)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
}

extension AZCRMViewController {
    
    func logout() {
        do {
            if let fCToken = try AppDelegate.context.fetch(FCToken.fetchRequest()) as? [FCToken] {
                if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                    if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                        
                        let param: Parameters = ["method": "logout","manv":entity.last!.manv!,"deviceid":fCToken.last!.fcmToken!,"seckey": urlRegister.last!.seckey!]
                        print(param)
                        Alamofire.request(urlRegister.last!.data!, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                            switch response.result {
                            case .success( _):
                                SVProgressHUD.show()
                                SVProgressHUD.dismiss(withDelay: 1, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            case .failure( _):
                                break
                            }
                        }
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
