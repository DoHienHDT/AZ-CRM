//
//  TakeCareOpportProductCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit

class TakeCareOpportProductCell: SwipeTableViewCell {

    @IBOutlet weak var maspLabel: UILabel!
    @IBOutlet weak var dienGiaiLabel: UILabel!
    @IBOutlet weak var tenSpLabel: UILabel!
    @IBOutlet weak var soluongLabel: UILabel!
    @IBOutlet weak var dongiaLabel: UILabel!
    @IBOutlet weak var thanhtienLabel: UILabel!
    @IBOutlet weak var tienckLabel: UILabel!
    @IBOutlet weak var tienvatLabel: UILabel!
    @IBOutlet weak var tongtienLabel: UILabel!
    @IBOutlet weak var heightDGLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //Log("layoutMargins = \(layoutMargins), contentView = \(contentView.bounds)")
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

