//
//  TakeCareOportCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit
class TakeCareOportCell: UITableViewCell {

    @IBOutlet weak var masoLabel: UILabel!
    @IBOutlet weak var ngaytaoLabel: UILabel!
    @IBOutlet weak var tiemnangLabel: UILabel!
    @IBOutlet weak var dienGiaiTextView: UITextView!
    @IBOutlet weak var thanhtoanLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        style(view: contentView)
    }
    
    func style(view: UIView) {
        view.maskToBounds = false
        view.backgroundColor = .white
//        view.cornerRadius = 14
        view.shadowColor = .black
        view.shadowOffset = CGSize(width: 1, height: 5)
        view.shadowRadius = 8
        view.shadowOpacity = 0.2
        view.shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 14, height: 14)).cgPath
        view.shadowShouldRasterize = true
        view.shadowRasterizationScale = UIScreen.main.scale
    }
}
    


