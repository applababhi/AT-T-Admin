//
//  Cell_INSPlanDetail_Header.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 29/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class Cell_INSPlanDetail_Header: UITableViewCell {

    @IBOutlet weak var collView:UICollectionView!

    func updateCollView()
    {
        if collView.delegate == nil
        {
            collView.delegate = self
            collView.dataSource = self
        }
        collView.reloadData()
    }
    
    var closure_UpdateString: (String)->Void = {(strTapped:String) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Cell_INSPlanDetail_Header : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return k_helper.arrHeader_INSPlanDetail.count
    }    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = k_helper.arrHeader_INSPlanDetail[indexPath.item]

        let cell:Coll_INSPlanDetail_Header = collectionView.dequeueReusableCell(withReuseIdentifier: "Coll_INSPlanDetail_Header", for: indexPath) as! Coll_INSPlanDetail_Header
        cell.lblTitle.text = ""
        cell.lblTitle.textColor = .darkGray
        cell.vLine.backgroundColor = .darkGray
        
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        if let chek:Bool = dict["selected"] as? Bool
        {
            if chek == true
            {
                cell.lblTitle.textColor = k_baseColor
                cell.vLine.backgroundColor = k_baseColor
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        for ind in 0..<k_helper.arrHeader_INSPlanDetail.count
        {
            var d:[String:Any] = k_helper.arrHeader_INSPlanDetail[ind]
            d["selected"] = false
            
            if indexPath.item == ind
            {
                d["selected"] = true
            }
            k_helper.arrHeader_INSPlanDetail[ind] = d
        }
        
        // update Base Controller
        let di:[String:Any] = k_helper.arrHeader_INSPlanDetail[indexPath.item]
        if let title:String = di["title"] as? String
        {
            self.closure_UpdateString(title)
        }
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    /*
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isPad
        {
            return CGSize(width: 150, height: 60)
        }
        else
        {
            return CGSize(width: 110, height: 60)
        }
    }
    */
}
