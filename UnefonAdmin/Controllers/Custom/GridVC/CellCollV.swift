//
//  CellCollV.swift
//  GridScroller
//
//  Created by Shalini Sharma on 31/8/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellCollV: UICollectionViewCell {
    
    @IBOutlet weak var imgLeft:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgRight:UIImageView!
    
    @IBOutlet weak var c_imgL_Wd:NSLayoutConstraint!
 //   @IBOutlet weak var c_imgR_Wd:NSLayoutConstraint!
        
}


class CellCollV_Header: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
}
