//
//  AddStaffTaskController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift
protocol AddStaffTaskControllerDelegate: class {
    func senData(vitri: String, nhanvien: String, diengiai: String, mavt: Int, manv: Int)
}

class AddStaffTaskController: BaseViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var manvhtsLabel: UILabel!
    @IBOutlet weak var mavtLabel: UILabel!
    @IBOutlet weak var diengiaiTextField: UITextField!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var heightNavigationView: NSLayoutConstraint!
    @IBOutlet weak var topButton: NSLayoutConstraint!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    var mavt: Int?
    var manv: Int?
    
    weak var delegate: AddStaffTaskControllerDelegate!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.dropShadow()
        do {
            if let entity = try AppDelegate.context.fetch(Entity.fetchRequest()) as? [Entity] {
                heightNavigationView.constant = CGFloat(entity.last!.heightNavigation)
                print(entity.last!.heightTopButton)
                topButton.constant = CGFloat(entity.last!.heightTopButton)
                heightTitle.constant = CGFloat(entity.last!.heightTitle)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        addButton.cornerRadius = 20
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.done
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = CGFloat(15)
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    @IBAction func addStaffButton(_ sender: UIButton) {
        if manvhtsLabel.text != " ",mavtLabel.text != " " {
            delegate.senData(vitri: mavtLabel.text!, nhanvien: manvhtsLabel.text!, diengiai: diengiaiTextField.text ?? "", mavt: mavt!, manv: manv!)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Cần nhập đủ dữ liệu", message: nil, preferredStyle: .alert)
            alert.addAction(title: "Ok", style: .cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func manvhtsAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .staff) { [unowned self] (info) in
            self.manvhtsLabel.text = info?.staff[1]
            self.manv = Int(info!.staff[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mavtAlertButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAlertAZSoft(Api: .tasktitles) { [unowned self] (info) in
            self.mavtLabel.text = info?.tasktitles[1]
            self.mavt = Int(info!.tasktitles[0])
        }
        let heightAlert:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        alert.view.addConstraint(heightAlert)
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
