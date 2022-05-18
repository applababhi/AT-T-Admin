//
//  Cell_INSUsuarioRows.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 5/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class Cell_INSUsuarioRows: UITableViewCell {

    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    @IBOutlet weak var lbl5:UILabel!
    @IBOutlet weak var lbl6:UILabel!
    @IBOutlet weak var lbl7:UILabel!
    
    @IBOutlet weak var v_Indicator:UIView!
    @IBOutlet weak var v_1:UIView!
    
    @IBOutlet weak var c_lbl1_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl2_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl3_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl4_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl5_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl6_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lbl7_Wd:NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
