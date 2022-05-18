//
//  CellMenu_Rows.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 8/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellMenu_Rows: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imagView:UIImageView!
    @IBOutlet weak var c_lbl_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_img_Ht:NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
