//
//  OportProcessCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class OportProcessCell: UITableViewCell {

    @IBOutlet weak var ngayXLLabel: UILabel!
    @IBOutlet weak var hinhThucTXLabel: UILabel!
    @IBOutlet weak var ndLabel: UILabel!
    @IBOutlet weak var nvQuanlyLabel: UILabel!
    @IBOutlet weak var ngayNhapLabel: UILabel!
    @IBOutlet weak var nguoiNhapLabel: UILabel!
    @IBOutlet weak var myView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.myView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
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

