//
//  TableViewCell.swift
//  GridScroller
//
//  Created by Shalini Sharma on 31/8/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellTbl_HorzRows: UITableViewCell {

    @IBOutlet weak var collV:UICollectionView!
    var isTextWhite:Bool = false
    var dateInRow:String = ""
    var changeBkColor = false
    var showDownArrow = false
    
    var useValue_ForAllCollScrollsHorz:Int!
    var isTopHeaderRow = false
    var isShowTopBlackHeaderTitlesInCenter = true
    var checkSpecialCase_DIS = false
    var checkSpecialCase_PO = false
    var isSecondSection = false
    
    var arrData:[[String:Any]] = [] {
        didSet{
            collV.delegate = self
            collV.dataSource = self
            
            collV.reloadData()
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

extension CellTbl_HorzRows : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CellCollV = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollV", for: indexPath) as! CellCollV
        
        cell.backgroundColor = UIColor.black // this will paint Black to all Rows in 2nd Table in collv
        
        cell.c_imgL_Wd.constant = 14
       // cell.c_imgR_Wd.constant = 16
        cell.lblTitle.text = ""
        cell.imgLeft.backgroundColor = .clear
        cell.imgRight.isHidden = true
                
        cell.lblTitle.textColor = .black
        if isTextWhite == true
        {
            cell.lblTitle.textColor = .white
        }
        
        if useValue_ForAllCollScrollsHorz == 3 && isTopHeaderRow == true
        {
            // for VS Dashboard, last long grid
            if isPad == true
            {
                cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 19.0)
            //    cell.c_imgL_Wd.constant = 1
            //    cell.c_imgR_Wd.constant = 1
            }
        }
        
        /* Skip this in this version, dont show dropdown arrow any where
        if showDownArrow == true
        {
            cell.imgRight.isHidden = false
        }
        */
        
        if changeBkColor == true
        {
            
            // check from Dict
            if let color:String = dict["background_color"] as? String
            {
                if color == "#2D2D2D"
                {
                    cell.backgroundColor = UIColor.black
                    cell.lblTitle.textColor = .white
                }
                else
                {
                    cell.backgroundColor = UIColor.colorWithHexString(color)
                }
            }
        }
        
        if let str:String = dict["value"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["header_name"] as? String
        {
            cell.lblTitle.text = str
        }
        
        if let check:Bool = dict["display_pointer"] as? Bool
        {
            if check == true
            {
                if let color:String = dict["pointer_color"] as? String
                {
                    cell.imgLeft.layer.cornerRadius = 7.0
                    cell.imgLeft.backgroundColor = UIColor.colorWithHexString(color)
                }
            }
        }
        
        cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 17)

        if cell.lblTitle.text!.count > 5
        {
            cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 13.3)
        }
        
        if isPad == false
        {
            // iPhone
            cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 10.0)
        }

        if checkSpecialCase_DIS == true && isSecondSection == true
        {
            // cell.backgroundColor = UIColor.colorWithHexString("#7D7C7C") // grey
            if indexPath.item >= 0 && indexPath.item < 4
            {
                // 1st group Black
                cell.backgroundColor =  .black
            }
            else if indexPath.item >= 4 && indexPath.item < 8
            {
                // 2nd group Yellow
                cell.backgroundColor =  UIColor(named: "Yellow")
            }
            else if indexPath.item >= 8 && indexPath.item < 12
            {
                // 3rd group Blue
                cell.backgroundColor =  UIColor(named: "customBlue")
            }
            else
            {
                // Pink
                cell.backgroundColor =  UIColor(named: "Pink")
            }
            
        }
        
        if checkSpecialCase_DIS == true && indexPath.item == arrData.count - 1 // last, always pink
        {
            cell.backgroundColor =  UIColor(named: "Pink")
            
            if cell.lblTitle.text! == ""
            {
                cell.backgroundColor = .black  // for First Section Header, last cell
            }
            
            if checkSpecialCase_PO == true
            {
                cell.backgroundColor = .black  // no pink for last cell in PO dashboard
                cell.lblTitle.textColor = .white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("< Row Tapped for - \(dateInRow) at \(indexPath.item) >")
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // Size for Each Cell
        
        if isPad
        {
            if useValue_ForAllCollScrollsHorz != 3
            {
                // for top 2 Grids
                return CGSize(width: 130, height: 60)
            }
            else
            {
                 // for 3rd Grids
                
                if useValue_ForAllCollScrollsHorz == 3 && isTopHeaderRow == true
                {
                    // for VS Dashboard, last long grid (Top Black Section Header)
                    if isPad == true
                    {
                        if isShowTopBlackHeaderTitlesInCenter == true
                        {
                            print("Manipulating width of each cell, just the header row")
                            
                            if indexPath.item % 2 == 0
                            {
                                return CGSize(width: 10, height: 40)
                            }
                            else
                            {
                                return CGSize(width: 230, height: 40)
                            }
                        }
                        else
                        {
                            // to show black header as regular cells, as rest cells in bottom rows
                            return CGSize(width: 120, height: 60)
                        }
                    }
                }
                
                return CGSize(width: 120, height: 60)
            }
        }
        else
        {
            return CGSize(width: 80, height: 60)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // On scroll of one collV, scroll all visible collV in other rows too Horizontly
        
       // print("Visible CollectionViews - - > ", k_helper.reffAll_CollV_ForGrid_1.count)
        
        // Set offset of all the collection view on horizontal scroll of anyone
        
        if collV == scrollView
        {
            if useValue_ForAllCollScrollsHorz == 1
            {
                for coll in k_helper.reffAll_CollV_ForGrid_1
                {
                    coll.contentOffset = scrollView.contentOffset
                }
            }
            else if useValue_ForAllCollScrollsHorz == 2
            {
                for coll in k_helper.reffAll_CollV_ForGrid_2
                {
                    coll.contentOffset = scrollView.contentOffset
                }
            }
            else if useValue_ForAllCollScrollsHorz == 3
            {
                for coll in k_helper.reffAll_CollV_ForGrid_3
                {
                    coll.contentOffset = scrollView.contentOffset
                }
            }
        }
    }
}
