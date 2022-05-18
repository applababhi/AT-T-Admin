//
//  CobCollV1VC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 10/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CobCollV1VC: UIViewController {

    @IBOutlet weak var collView:UICollectionView!
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
    }
}

extension CobCollV1VC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CobCollV1Cell = collView.dequeueReusableCell(withReuseIdentifier: "CobCollV1Cell", for: indexPath) as! CobCollV1Cell
        
        cell.lblSubtitle.text = ""
        cell.lblTitle.text = ""
                
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["subTitle"] as? String
        {
            cell.lblSubtitle.text = str
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    { }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func viewWillLayoutSubviews() {
        collView.reloadData() // this will reload the collV in each orientation then set size
    }
    
    /*
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
    */
    
        // To make Cells Display in Center
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            /*
            if isPad
            {
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
                {
                    let totalCellWidth = 120 * collectionView.numberOfItems(inSection: 0)
                    let totalSpacingWidth = 0
    
                    let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
                    let rightInset = leftInset
    
                    print("- - - - -LANDScape Bar - - - - - - -")
                    return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
                }
                else
                {
                    let totalCellWidth = 120 * collectionView.numberOfItems(inSection: 0)
                    let totalSpacingWidth = 0
    
                    let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
                    let rightInset = leftInset
    
                    print("- - - - - PORTRait Bar- - - - - - -")
                    return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
                }
            }
            else
            {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            */
        }
    

}
