//
//  OpportProcessController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import Alamofire
import SVProgressHUD
class OpportProcessController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    
    var oportProcess = [OportProcessModel]()
    var manc: Int?
    var maso: String?
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
        
        tableView.isHidden = true
        tableView.register(UINib(nibName: "OportProcessCell", bundle: nil), forCellReuseIdentifier: "OportProcessCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiOportProcess()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  oportProcess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OportProcessCell", for: indexPath) as! OportProcessCell
            cell.ndLabel.text = oportProcess[indexPath.row].noidung
            cell.hinhThucTXLabel.text = oportProcess[indexPath.row].hinhthuc
            cell.ngayNhapLabel.text = oportProcess[indexPath.row].ngaytao
            cell.nguoiNhapLabel.text = oportProcess[indexPath.row].nguoitao
            cell.nvQuanlyLabel.text = oportProcess[indexPath.row].nguoiquanly
            cell.ngayXLLabel.text = oportProcess[indexPath.row].ngayxl
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HandingViewController {
            vc.manc = manc
            vc.maso = maso
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addOpportProcess(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if oportProcess[indexPath.row].noidung != "" {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let text: [AttributedTextBlock] = [
                .normal(""),
                .header1("Nội dung:"),
                .normal("\(oportProcess[indexPath.row].noidung)")]
            alert.addTextViewer(text: .attributedText(text))
            alert.addAction(title: "OK",color: .red, style: .cancel)
            alert.show()
        }
    }
}

extension OpportProcessController {
    
    func apiOportProcess() {
        do {
            if let urlRegister = try AppDelegate.context.fetch(CompanyCode.fetchRequest()) as? [CompanyCode] {
                let param: Parameters = ["method": "opportunityprocess","manc":manc!,"seckey": urlRegister.last!.seckey!]
                print("Method opportunityprocess: \(param) ")
                RequestOportProcess.getOportProcess(parameter: param) { (response) in
                    self.oportProcess = response
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

