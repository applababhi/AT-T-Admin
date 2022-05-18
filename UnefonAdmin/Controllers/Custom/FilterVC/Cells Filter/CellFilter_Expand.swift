//
//  CellFilter_Expand.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 8/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellFilter_Expand: UITableViewCell {

 //   @IBOutlet weak var imgViewDrop:UIImageView!
    @IBOutlet weak var vCheckMark:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnArrow:UIButton!
    @IBOutlet weak var collView:UICollectionView!
    
    var SubRegionTapIndex:Int!
    
    var updateArrayClosure: ([[String:Any]], Int) -> Void = {(arr:[[String:Any]], indexSection:Int) in }
    
    var arr_sub_regions:[[String:Any]] = [] {
        didSet{
            if collView.delegate == nil
            {
                collView.delegate = self
                collView.dataSource = self
            }
            collView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellFilter_Expand : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arr_sub_regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0  // for this version as we are not showing states , so no need to show nested CollV Rows
        
        let d:[String:Any] = arr_sub_regions[section]
        if let ar:[[String:Any]] = d["states"] as? [[String:Any]]
        {
            return ar.count
        }
        return 0
    }
    
    // Header for Collection View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollFilter_HeaderExpand", for: indexPath) as! CollFilter_HeaderExpand
        
        header.lblTitle.text = ""
//        header.imgViewDrop.setImageColor(color: UIColor.white)
        
        header.vCheckMark.layer.cornerRadius = 5.0
        header.vCheckMark.layer.borderWidth = 1.4
        header.vCheckMark.layer.borderColor = UIColor.white.cgColor
        header.vCheckMark.layer.masksToBounds = true
        header.vCheckMark.backgroundColor = .clear
        
        let d:[String:Any] = arr_sub_regions[indexPath.section]
        
        if let str:String = d["sub_region_name"] as? String
        {
            header.lblTitle.text = str
        }
        
        if let check:Bool = d["is_selected"] as? Bool
        {
            if check == true
            {
                header.vCheckMark.backgroundColor = UIColor(named: "customBlue")
            }
        }
        
        header.btnArrow.tag = indexPath.section
        header.btnArrow.addTarget(self, action: #selector(self.btnRegionEachSectionTap(btn:)), for: .touchUpInside)

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let d:[String:Any] = arr_sub_regions[indexPath.section]

        let cell:CollFilter_Row = collectionView.dequeueReusableCell(withReuseIdentifier: "CollFilter_Row", for: indexPath) as! CollFilter_Row
        cell.lblTitle.text = ""
        cell.vCheckMark.layer.cornerRadius = 5.0
        cell.vCheckMark.layer.borderWidth = 1.4
        cell.vCheckMark.layer.borderColor = UIColor.white.cgColor
        cell.vCheckMark.layer.masksToBounds = true
        cell.vCheckMark.backgroundColor = .clear
        
        if let ar:[[String:Any]] = d["states"] as? [[String:Any]]
        {
            let di:[String:Any] = ar[indexPath.item]
            if let str:String = di["state_name"] as? String
            {
                cell.lblTitle.text = str
            }
            
            if let check:Bool = di["is_selected"] as? Bool
            {
                if check == true
                {
                    cell.vCheckMark.backgroundColor = UIColor(named: "customBlue")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let btn:UIButton = UIButton()
        btn.tag = indexPath.section
        btn.setTitle(".", for: .normal)
        btnRegionEachSectionTap(btn: btn) // this will fiorst deselect if all is selected
        
        var dEachRegion:[String:Any] = arr_sub_regions[indexPath.section]
        
        if let ar:[[String:Any]] = dEachRegion["states"] as? [[String:Any]]
        {
            var arState:[[String:Any]] = ar
            var diState:[String:Any] = arState[indexPath.item]
            
            if let check:Bool = diState["is_selected"] as? Bool
            {
                if check == true
                {
                    diState["is_selected"] = false
                }
                else
                {
                     diState["is_selected"] = true
                }
                
                arState[indexPath.item] = diState
                dEachRegion["states"] = arState
                arr_sub_regions[indexPath.section] = dEachRegion
                self.updateArrayClosure(arr_sub_regions, SubRegionTapIndex)
            }
        }
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc func btnRegionEachSectionTap(btn:UIButton)
    {
        // its a main Section of each region
        var d_EachSubRegion:[String:Any] = arr_sub_regions[btn.tag]
        
        var strTitle:String = ""
        if let str:String = btn.titleLabel?.text
        {
            strTitle = str
        }
        
        btn.setTitle("", for: .normal)
        
        if let check:Bool = d_EachSubRegion["is_selected"] as? Bool
        {
            if check == false && strTitle == "."  // "."  will only come when tap on didSelectItemAtIndexpath
            {
                return
            }
            
            if check == false
            {
                d_EachSubRegion["is_selected"] = true
                
                if let a_StatesT:[[String:Any]] = d_EachSubRegion["states"] as? [[String:Any]]
                {
                    var a_States = a_StatesT
                    for index in 0..<a_States.count
                    {
                        var d_State:[String:Any] = a_States[index]
                        d_State["is_selected"] = true
                        a_States[index] = d_State
                    }
                    d_EachSubRegion["states"] = a_States
                }
                arr_sub_regions[btn.tag] = d_EachSubRegion
                self.updateArrayClosure(arr_sub_regions, SubRegionTapIndex)
            }
            else
            {
                d_EachSubRegion["is_selected"] = false
                
                if let a_StatesT:[[String:Any]] = d_EachSubRegion["states"] as? [[String:Any]]
                {
                    var a_States = a_StatesT
                    for index in 0..<a_States.count
                    {
                        var d_State:[String:Any] = a_States[index]
                        d_State["is_selected"] = false
                        a_States[index] = d_State
                    }
                    d_EachSubRegion["states"] = a_States
                }
                arr_sub_regions[btn.tag] = d_EachSubRegion
                self.updateArrayClosure(arr_sub_regions, SubRegionTapIndex)
            }
        }
    }
}
