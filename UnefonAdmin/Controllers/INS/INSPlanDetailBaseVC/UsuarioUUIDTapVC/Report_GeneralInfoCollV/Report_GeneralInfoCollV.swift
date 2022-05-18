//
//  Report_GeneralInfoCollV.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class Report_GeneralInfoCollV: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
    }
    
}

extension Report_GeneralInfoCollV : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_Report_Info = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_Report_Info", for: indexPath) as! CollCell_Report_Info
        
        cell.lblSubtitle.text = ""
        cell.lblTitle.text = ""
                
        if let str:String = dict["title"] as? String
        {
            cell.lblSubtitle.text = str
        }
        if let str:String = dict["label"] as? String
        {
            cell.lblTitle.text = str
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    { }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func viewWillLayoutSubviews() {
        collView.reloadData() // this will reload the collV in each orientation then set size
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = self.collView.frame.size.width
        
        if isPad == true
        {
            return CGSize(width: (width/4.0) - 5, height: 90)
        }
        else
        {
            return CGSize(width: 90, height: 90)
        }
    }
}
