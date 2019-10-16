//
//  ListScheduleCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class ListScheduleCell: SwipeTableViewCell {

    @IBOutlet weak var tieudeLbael: UILabel!
    @IBOutlet weak var ngaybdLabel: UILabel!
    @IBOutlet weak var ngayktLabel: UILabel!
    @IBOutlet weak var diadiemLabel: UILabel!
    @IBOutlet weak var noidungLabel: UILabel!
    @IBOutlet weak var manvLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
