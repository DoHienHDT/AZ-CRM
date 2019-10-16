//
//  FllowWorkController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import Alamofire
protocol FllowWorkControllerDelegate: class {
    func reloadData()
}
class FllowWorkController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    
    var listFollow = [FollowWorkModel]()
    var macv: Int?
    weak var delegate: FllowWorkControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
                topButtonRight.constant = CGFloat(entity.last!.heightTopButtonRight)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        tableView.register(UINib(nibName: "FollowWorkCell", bundle: nil), forCellReuseIdentifier: "FollowWorkCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                // Do any additional setup after loading the view.
                let param: Parameters = ["method": "taskprocess","macv":macv!,"seckey": urlRegister.last!.seckey!]
                FollowWorkRequest.getfollow(parameter: param) { [unowned self] (follow) in
                    self.listFollow = follow
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddProcessTaskController {
            vc.macv = macv
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        delegate.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addProcessButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addProcessTask", sender: self)
    }
}

extension FllowWorkController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowWorkCell", for: indexPath) as! FollowWorkCell
            cell.ngaynhapLabel.text = listFollow[indexPath.row].ngaynhap
            cell.ngayxlLabel.text = listFollow[indexPath.row].ngayxl
            cell.nguoinhapLabel.text = listFollow[indexPath.row].nguoinhap
            cell.mandLabel.text = listFollow[indexPath.row].noidung
            cell.tiendoLabel.text = listFollow[indexPath.row].tiendo.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listFollow[indexPath.row].noidung != "" {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let text: [AttributedTextBlock] = [
                .normal(""),
                .header1("Nội dung:"),
                .normal("\(listFollow[indexPath.row].noidung)")]
            alert.addTextViewer(text: .attributedText(text))
            alert.addAction(title: "OK",color: .red, style: .cancel)
            alert.show()
        }
    }
}
