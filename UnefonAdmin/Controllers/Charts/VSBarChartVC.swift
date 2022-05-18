//
//  VSBarChartVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 11/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class VSBarChartVC: UIViewController {
    
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var vLegend1:UIView!
    @IBOutlet weak var vLegend2:UIView!
    @IBOutlet weak var vLegend3:UIView!
    @IBOutlet weak var vLegend4:UIView!
    
    @IBOutlet weak var lblLegend1:UILabel!
    @IBOutlet weak var lblLegend2:UILabel!
    @IBOutlet weak var lblLegend3:UILabel!
    @IBOutlet weak var lblLegend4:UILabel!
    
    @IBOutlet weak var btnOverlayRight_iPhone:UIButton!
    
    var arrBars_InCollection:[[String:Any]] = []
    var maxIndexForFullArray:Int = 0
   // var arr_EachIndexCollV:[[String:Any]] = []
    var currentShowingIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vLegend1.layer.cornerRadius = 8.0
        vLegend1.layer.masksToBounds = true
        vLegend2.layer.cornerRadius = 8.0
        vLegend2.layer.masksToBounds = true
        vLegend3.layer.cornerRadius = 8.0
        vLegend3.layer.masksToBounds = true
        vLegend4.layer.cornerRadius = 8.0
        vLegend4.layer.masksToBounds = true
        
        lblLegend1.text = "UNEFON"
        lblLegend2.text = "AT&T"
        lblLegend3.text = "PREPAGO"
        lblLegend4.text = "KPI"
        
//        [UIColor(named: "Yellow"), UIColor(named: "customBlue"), UIColor(named: "Gray Base"), UIColor.darkGray]
        vLegend1.backgroundColor = UIColor(named: "Yellow")
        vLegend2.backgroundColor = UIColor(named: "customBlue")
        vLegend3.backgroundColor = UIColor(named: "Gray Base")
        vLegend4.backgroundColor = UIColor.darkGray
        
        collView.isPagingEnabled = true
        maxIndexForFullArray = arrBars_InCollection.count - 1
        collView.delegate = self
        collView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collView.reloadData()
    }
    
    @IBAction func btnLeftClick(btn:UIButton)
    {
        print("Left Click")
        currentShowingIndex = currentShowingIndex - 1
        
        if currentShowingIndex <= 0
        {
            currentShowingIndex = 0
        }
        else
        {
          
        }
        
        let lastIndex = IndexPath(item: currentShowingIndex, section: 0)
        self.collView.scrollToItem(at: lastIndex, at: .left, animated: true)
    }
    
    @IBAction func btnRightClick(btn:UIButton)
    {
        print("Right Click")
        currentShowingIndex = currentShowingIndex + 1
        
        if  currentShowingIndex >= maxIndexForFullArray
        {
            currentShowingIndex = arrBars_InCollection.count - 1
        }
        else
        {

        }
        
        let lastIndex = IndexPath(item: currentShowingIndex, section: 0)
        self.collView.scrollToItem(at: lastIndex, at: .right, animated: true)
    }
}

extension VSBarChartVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBars_InCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrBars_InCollection[indexPath.item]
        
        let cell:CollCellVSBar = collView.dequeueReusableCell(withReuseIdentifier: "CollCellVSBar", for: indexPath) as! CollCellVSBar
        cell.lblWeekName.text = ""
        cell.lblWeekRange.text = ""
        
        var dict2pasBar:[String:Any] = [:]
        
        if let str:String = dict["week_name"] as? String
        {
            cell.lblWeekName.text = str
        }
        if let str:String = dict["description"] as? String
        {
            cell.lblWeekRange.text = str
        }
        
        // create 4 bars in each dict either double or int
        if let d:Double = dict["unefon_inar_sales_counter"] as? Double
        {
            dict2pasBar["unefon_inar_sales_counter"] = d
        }
        if let d:Int = dict["unefon_inar_sales_counter"] as? Int
        {
            dict2pasBar["unefon_inar_sales_counter"] = d
        }
        if let d:Double = dict["att_inar_sales_counter"] as? Double
        {
            dict2pasBar["att_inar_sales_counter"] = d
        }
        if let d:Int = dict["att_inar_sales_counter"] as? Int
        {
            dict2pasBar["att_inar_sales_counter"] = d
        }
        if let d:Double = dict["general_inar_sales_counter"] as? Double
        {
            dict2pasBar["general_inar_sales_counter"] = d
        }
        if let d:Int = dict["general_inar_sales_counter"] as? Int
        {
            dict2pasBar["general_inar_sales_counter"] = d
        }
        if let d:Double = dict["general_inar_kpi"] as? Double
        {
            dict2pasBar["general_inar_kpi"] = d
        }
        if let d:Int = dict["general_inar_kpi"] as? Int
        {
            dict2pasBar["general_inar_kpi"] = d
        }
        
        
        if isPad == false
        {
            cell.lblWeekName.font = UIFont(name: CustomFont.regular, size: 10)
            cell.lblWeekRange.font = UIFont(name: CustomFont.regular, size: 7)
        }
        
        cell.showBarChart(dictEachCell: dict2pasBar)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    /*
    // To make Cells Display in Center
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if isPad
        {
            let eachCellWidth = collectionView.layer.frame.size.width - 100
            
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
            {
                let totalCellWidth = Int(eachCellWidth) * collectionView.numberOfItems(inSection: 0)
                let totalSpacingWidth = 0
                
                let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
                let rightInset = leftInset
                
                print("- - - - -LANDScape Bar - - - - - - -")
                return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
            }
            else
            {
                let totalCellWidth = Int(eachCellWidth) * collectionView.numberOfItems(inSection: 0)
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
        
    }
    */
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isPad
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
            {
                return CGSize(width: collectionView.frame.size.width, height: 200)
            }
            else
            {
                return CGSize(width: self.view.frame.size.width - 50, height: 200)
            }
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width, height: 200)
        }
    }
}

extension VSBarChartVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}
