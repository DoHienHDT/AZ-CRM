//
//  ListTaskCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class ListTaskCell: SwipeTableViewCell {

    @IBOutlet weak var nguoinhapLabel: UILabel!
    @IBOutlet weak var tencvLabel: UILabel!
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var mattLabel: UILabel!
    @IBOutlet weak var matdLabel: UILabel!
    @IBOutlet weak var mattButton: UIButton!
    @IBOutlet weak var tenkhLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

