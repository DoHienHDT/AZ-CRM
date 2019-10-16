//
//  OpportTableViewCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class OpportTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var masoLabel: UILabel!
    @IBOutlet weak var potentialLabel: UILabel!
    
    var indicatorView = IndicatorView(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        myView.backgroundColor = .red
        // Configure the view for the selected state
    }
    
}
