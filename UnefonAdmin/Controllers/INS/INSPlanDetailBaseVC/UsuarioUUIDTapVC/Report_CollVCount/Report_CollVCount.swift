
//
//  Report_CollVCount.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class Report_CollVCount: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collView:UICollectionView!

    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.collView.delegate = self
        self.collView.dataSource = self
          
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collView?.setCollectionViewLayout(layout, animated: true)
        self.collView.reloadData()
    }

}

extension Report_CollVCount : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]

        let cell:Coll_INSPlanDetail_Counts = collectionView.dequeueReusableCell(withReuseIdentifier: "Coll_INSPlanDetail_Counts", for: indexPath) as! Coll_INSPlanDetail_Counts
        cell.lblTitle.text = ""
        cell.lblCount.text = ""
        cell.lblTitle.textColor = .lightGray
        cell.vBk.layer.cornerRadius = 6.0
        cell.vBk.layer.borderWidth = 1.0
        cell.vBk.layer.borderColor = UIColor.darkGray.cgColor
        cell.vBk.layer.masksToBounds = true
        
        if let str:String = dict["label"] as? String
        {
            cell.lblTitle.text = str
            
            if cell.lblTitle.text!.count > 14
            {
                cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 15)
            }
            
        }
        if let str:String = dict["title"] as? String
        {
            cell.lblCount.text = str
        }
        
        if indexPath.item == 0
        {
            cell.lblCount.textColor = UIColor.colorWithHexString("#36817A") // green
        }
        else if indexPath.item == 1
        {
            cell.lblCount.textColor = UIColor(named: "Pink")
        }        
        else
        {
            cell.lblCount.textColor = UIColor(named: "Purple")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {}
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isPad == true
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
            {
                return CGSize(width: 255, height: 120)
            }
            else
            {
                return CGSize(width: 210, height: 120)
            }
        }
        // iPhone
        return CGSize(width: 190, height: 110)
    }
}
