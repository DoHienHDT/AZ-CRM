//
//  FilterOrderController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit

protocol FilterOrderControllerDelegate: class {
    func senFilterData(matt: String, mact: String, tungay: String, denngay: String, status: String)
}

class FilterOrderController: BaseViewController {
    
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var chinhanhLabel: UILabel!
    @IBOutlet weak var tungayLabel: UILabel!
    @IBOutlet weak var denngayLabel: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var topButtonRight: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    weak var delegate: FilterOrderControllerDelegate!
    var matt: String?
    var mact: String?
    
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
        
        let date = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        let dateString = dateformat.string(from: date)
        let previousMonth = Calendar.current.date(byAdding: .month, value: -3, to: date)!
        let previousMonthString = dateformat.string(from: previousMonth)
        
        denngayLabel.text = dateString
        tungayLabel.text = previousMonthString
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mattAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .orderstatus) { (info) in
            self.mattLabel.text = info?.orderstatus[1]
            self.matt = info?.orderstatus[0]
            
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mactAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .companies) { (info) in
            self.chinhanhLabel.text = info?.companies[1]
            self.mact = info?.companies[0]
        }
        
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tungayAlertButton(_ sender: UIButton) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.tungayLabel.text = todayString
        
        let alert = UIAlertController(title: "Từ ngày", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.tungayLabel.text = dateOfBirth
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.tungayLabel.text =  " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func denngayAlertButton(_ sender: Any) {
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormat.string(from: today)
        self.denngayLabel.text = todayString
        
        let alert = UIAlertController(title: "Đến ngày", message: nil, preferredStyle: .actionSheet)
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { [unowned self] (date) in
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let dateOfBirth = dateFormat.string(from: date)
            
            self.denngayLabel.text = dateOfBirth
            Log(date)
        }
        
        alert.addAction(title: "Done",color: .red, style: .default)
        
        alert.addAction(title: "Cancel",color: .red , style: .cancel) { _ in
            self.denngayLabel.text =  " "
        }
        
        present(alert, animated: true  , completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func successButton(_ sender: UIButton) {
        delegate.senFilterData(matt: matt ?? "", mact: mact ?? "", tungay: tungayLabel.text ?? "", denngay: denngayLabel.text ?? "", status: mattLabel.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
}

