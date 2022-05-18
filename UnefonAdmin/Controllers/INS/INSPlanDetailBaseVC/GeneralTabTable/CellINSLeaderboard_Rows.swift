//
//  CellINSLeaderboard_Rows.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 29/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellINSLeaderboard_Rows: UITableViewCell {

    @IBOutlet weak var lbl_Position:UILabel!
    @IBOutlet weak var lbl_Distributor:UILabel!
    @IBOutlet weak var lbl_Activa:UILabel!
    @IBOutlet weak var lbl_Percent:UILabel!
    
    @IBOutlet weak var c_lblAct_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lblLorgo_Wd:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
