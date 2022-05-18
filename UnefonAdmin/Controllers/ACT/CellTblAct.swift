//
//  CellTblAct.swift
//  UnefonAdmin
//
//  Created by Abhishek Visa on 18/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellTblAct: UITableViewCell {

    @IBOutlet weak var lblLeft:UILabel!
    @IBOutlet weak var lblRight:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
