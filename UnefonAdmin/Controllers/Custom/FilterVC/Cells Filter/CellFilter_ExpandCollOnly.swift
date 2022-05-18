//
//  CellFilter_ExpandCollOnly.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 8/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellFilter_ExpandCollOnly: UITableViewCell {

    @IBOutlet weak var vCheckMark:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnArrow:UIButton!

    @IBOutlet weak var collView:UICollectionView!
    
  //  var d_Channels:[String:Any] = [:] {
    var arr_Channels:[[String:Any]] = [] {
        didSet{
            if collView.delegate == nil
            {
                collView.delegate = self
                collView.dataSource = self
            }
            collView.reloadData()
        }
    }
    
    var SubChannelTapIndex:Int!
    var updateArrayClosure: ([[String:Any]], Int) -> Void = {(arr:[[String:Any]], indexSection:Int) in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellFilter_ExpandCollOnly : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arr_Channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let d_Channels:[String:Any] = arr_Channels[indexPath.row] // because always content inside it comes in index Zero
        
        let cell:CollFilter_Row = collectionView.dequeueReusableCell(withReuseIdentifier: "CollFilter_Row", for: indexPath) as! CollFilter_Row
        cell.lblTitle.text = ""
        cell.vCheckMark.layer.cornerRadius = 5.0
        cell.vCheckMark.layer.borderWidth = 1.4
        cell.vCheckMark.layer.borderColor = UIColor.white.cgColor
        cell.vCheckMark.layer.masksToBounds = true
        cell.vCheckMark.backgroundColor = .clear
        
        if let str:String = d_Channels["channel_name"] as? String
        {
            cell.lblTitle.text = str
        }
        
        if let check:Bool = d_Channels["is_selected"] as? Bool
        {
            if check == true
            {
                cell.vCheckMark.backgroundColor = UIColor(named: "customBlue")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var d_Channels:[String:Any] = arr_Channels[indexPath.row]

        if let check:Bool = d_Channels["is_selected"] as? Bool
        {
            if check == true
            {
                d_Channels["is_selected"] = false
            }
            else
            {
                d_Channels["is_selected"] = true
            }
            
            arr_Channels[indexPath.row] = d_Channels

            self.updateArrayClosure(arr_Channels, SubChannelTapIndex)
        }
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc func btnChannelEachSectionTap(btn:UIButton)
    {
        // its a main Section of each region
        print(btn.tag)
    }
}
