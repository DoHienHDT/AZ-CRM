//
//  OderTableViewCell.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

class OderTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var nhanvienLb: UILabel!
    @IBOutlet weak var trangthaiLb: UILabel!
    @IBOutlet weak var diadiemLb: UILabel!
    @IBOutlet weak var ngayDhLb: UILabel!
    @IBOutlet weak var doituongLb: UILabel!
    @IBOutlet weak var sophieuLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

