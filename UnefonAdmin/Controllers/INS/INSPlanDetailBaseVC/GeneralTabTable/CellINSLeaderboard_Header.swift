//
//  CellINSLeaderboard_Header.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 29/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellINSLeaderboard_Header: UITableViewCell {    
    
    @IBOutlet weak var lblDashboard:UILabel!
    @IBOutlet weak var lblAct:UILabel!
    @IBOutlet weak var lblLorgo:UILabel!
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
