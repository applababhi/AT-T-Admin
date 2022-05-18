//
//  CellUUIDtap_Header.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 6/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellUUIDtap_Header: UITableViewCell {

    @IBOutlet weak var imgV:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubtitle:UILabel!
    @IBOutlet weak var btnEmail:UIButton!
    @IBOutlet weak var btnPhone:UIButton!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var c_lblTitle_Ld:NSLayoutConstraint!
    @IBOutlet weak var c_lblTitle_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_btnBk_Wd:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
