//
//  CobCollV2Cell.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 10/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CobCollV2Cell: UICollectionViewCell {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubtitle:UILabel!

    @IBOutlet weak var c_img_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_img_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_img_Tp:NSLayoutConstraint!
}
