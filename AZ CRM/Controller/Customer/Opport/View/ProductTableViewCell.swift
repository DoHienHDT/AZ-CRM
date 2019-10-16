//
//  ProductTableViewCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class ProductTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var spLabel: UILabel!
    @IBOutlet weak var tienCKLabel: UILabel!
    @IBOutlet weak var tienVatLabel: UILabel!
    @IBOutlet weak var tongTienLabel: UILabel!
    @IBOutlet weak var thanhTienLabel: UILabel!
    @IBOutlet weak var soluongLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

