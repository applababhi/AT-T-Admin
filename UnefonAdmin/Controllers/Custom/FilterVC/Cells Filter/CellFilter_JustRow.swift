//
//  CellFilter_JustRow.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 8/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellFilter_JustRow: UITableViewCell {

    @IBOutlet weak var vCheckMark:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
