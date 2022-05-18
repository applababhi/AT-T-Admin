//
//  VSVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 9/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class VSVC: UIViewController {
    
    @IBOutlet weak var lblNoData:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    
    var dictMain:[String:Any] = [:]
    var arrData:[[String:Any]] = []   // Total 5 UI Elements
    var is_Landscape = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        k_helper.reffAll_CollV_ForGrid_1.removeAll()
        k_helper.reffAll_CollV_ForGrid_2.removeAll()
        k_helper.reffAll_CollV_ForGrid_3.removeAll()
        
      //  print(dictMain.json)
        
        if dictMain.count == 0
        {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }
        
        if let d1:[String:Any] = dictMain["inar_table"] as? [String:Any] // Grid 1
        {
            if let title:String = d1["table_name"] as? String
            {
                arrData.append(["title":title, "data":d1])
            }
        }
        if let d2:[String:Any] = dictMain["ef_table"] as? [String:Any]  // Grid 2
        {
            if let title:String = d2["table_name"] as? String
            {
                arrData.append(["title":title, "data":d2])
            }
        }
        if let d3:[String:Any] = dictMain["ef_totals"] as? [String:Any]  // Pie Chart
        {
            if let d4:[String:Any] = dictMain["inar_totals"] as? [String:Any]
            {
                let arr:[[String:Any]] = [d3, d4] // first ef Data, then Inar Data Dict
                arrData.append(["title":"Activaciones por Compañía", "data":arr])
            }
        }
        if let a5:[[String:Any]] = dictMain["weeks"] as? [[String:Any]]   // Bar Chart
        {
            arrData.append(["title":"Activaciones Por Semana", "data":a5])
        }
        if let d6:[String:Any] = dictMain["days_table"] as? [String:Any]  // Grid 3
        {
            if let title:String = d6["table_name"] as? String
            {
                arrData.append(["title":title, "data":d6])
            }
        }
        
        collView.delegate = self
        collView.dataSource = self
    }
}

extension VSVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCellVS = collView.dequeueReusableCell(withReuseIdentifier: "CollCellVS", for: indexPath) as! CollCellVS
        cell.lblTitle.text = ""
        cell.viewParent.backgroundColor = UIColor.clear
        
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        
        for views in cell.viewParent.subviews
        {
            views.removeFromSuperview()
        }
        
        switch indexPath.item
        {
        case 0:
            // grid 1
            
            if let d1:[String:Any] = dict["data"] as? [String:Any]
            {
                if let arAll:[[[String:Any]]] = d1["content"] as? [[[String:Any]]]
                {
                    if arAll.count > 0
                    {
                        let a_First:[[String:Any]] = arAll.first!
                        var arRest:[[[String:Any]]] = []
                        for index in 1..<arAll.count
                        {
                            let aEach:[[String:Any]] = arAll[index]
                            arRest.append(aEach)
                        }
                        
                        let controller: GridVC = AppStoryBoards.Customs.instance.instantiateViewController(withIdentifier: "GridVC_ID") as! GridVC
                        controller.useValue_ForAllCollScrollsHorz = 1
                        controller.arrFirstSection = a_First
                        controller.arrMain = arRest
                        controller.view.frame = cell.viewParent.bounds;
                        controller.willMove(toParent: self)
                        cell.viewParent.addSubview(controller.view)
                        self.addChild(controller)
                        controller.didMove(toParent: self)
                    }
                }
            }
            break
        case 1:
            // grid 2
            if let d2:[String:Any] = dict["data"] as? [String:Any]
            {
                if let arAll:[[[String:Any]]] = d2["content"] as? [[[String:Any]]]
                {
                    if arAll.count > 0
                    {
                        let a_First:[[String:Any]] = arAll.first!
                        var arRest:[[[String:Any]]] = []
                        for index in 1..<arAll.count
                        {
                            let aEach:[[String:Any]] = arAll[index]
                            arRest.append(aEach)
                        }
                        
                        
                        let controller: GridVC = AppStoryBoards.Customs.instance.instantiateViewController(withIdentifier: "GridVC_ID") as! GridVC
                        controller.arrFirstSection = a_First
                        controller.useValue_ForAllCollScrollsHorz = 2
                        controller.arrMain = arRest
                        controller.view.frame = cell.viewParent.bounds;
                        controller.willMove(toParent: self)
                        cell.viewParent.addSubview(controller.view)
                        self.addChild(controller)
                        controller.didMove(toParent: self)
                    }
                }
            }
            break
        case 2:
            // pie chart
            
            cell.viewParent.layer.borderWidth = 0.6
            
            let controller: VSPieChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "VSPieChartVC_ID") as! VSPieChartVC
            
            if let arD:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                let cisDict:[String:Any] = arD.first!
                let inarDict:[String:Any] = arD.last!
                
                /*
                if let strPerc:String = cisDict["performance_str"] as? String
                {
                    controller.str_innerHolePercentage_Act = strPerc
                }
                */
                if let cisD:String = cisDict["unefon_sales_sum_str"] as? String
                {
                    controller.str_CisDisplay_Act = cisD
                }
                if let cisV:Int = cisDict["unefon_sales_sum"] as? Int
                {
                    if let inarV:Int = inarDict["unefon_sales_sum"] as? Int
                    {
                        controller.value_Cis_Act = Double(inarV)
                        controller.value_Inar_Act = Double(cisV) - Double(inarV)
                        
                        let perc = (Double(inarV)/Double(cisV)) * 100
                        let percDisplay = perc.rounded(toPlaces: 1)
                        controller.str_innerHolePercentage_Act = "\(percDisplay)" + "%"
                    }
                    
                }
                if let cisV:Double = cisDict["unefon_sales_sum"] as? Double
                {
                    if let inarV:Double = inarDict["unefon_sales_sum"] as? Double
                    {
                        controller.value_Cis_Act = inarV
                        controller.value_Inar_Act =  cisV - inarV
                        
                        let perc = (inarV/cisV) * 100
                        
                        controller.str_innerHolePercentage_Act = "\(perc.rounded(toPlaces: 1)) %"

                    }
                }
                
                if let cisD:String = cisDict["att_sales_sum_str"] as? String
                {
                    controller.str_CisDisplay_Kpi = cisD
                }
                if let cisV:Int = cisDict["att_sales_sum"] as? Int
                {
                    if let inarV:Int = inarDict["att_sales_sum"] as? Int
                    {
                        controller.value_Cis_Kpi = Double(inarV)
                        controller.value_Inar_Kpi =  Double(cisV) - Double(inarV)
                        
                        let perc = (Double(inarV)/Double(cisV)) * 100
                        let percDisplay = perc.rounded(toPlaces: 1)

                        controller.str_innerHolePercentage_Kpi = "\(percDisplay) %"
                    }
                }
                if let cisV:Double = cisDict["att_sales_sum"] as? Double
                {
                    if let inarV:Double = inarDict["att_sales_sum"] as? Double
                    {
                        controller.value_Cis_Kpi = inarV
                        controller.value_Inar_Kpi = cisV - inarV

                        let perc = (inarV/cisV) * 100
                        controller.str_innerHolePercentage_Kpi = "\(perc.rounded(toPlaces: 1)) %"
                    }
                }
                
                
                if let cisD:String = cisDict["sales_sum_str"] as? String
                {
                    controller.str_CisDisplay_3rd = cisD
                }
                if let cisV:Int = cisDict["sales_sum"] as? Int
                {
                    if let inarV:Int = inarDict["sales_sum"] as? Int
                    {
                        controller.value_Cis_3rd = Double(inarV)
                        controller.value_Inar_3rd = Double(cisV) - Double(inarV)
                        
                        let perc = (Double(inarV)/Double(cisV)) * 100
                        let percDisplay = perc.rounded(toPlaces: 1)

                        controller.str_innerHolePercentage_3rd = "\(percDisplay) %"
                    }
                }
                if let cisV:Double = cisDict["sales_sum"] as? Double
                {
                    if let inarV:Double = inarDict["sales_sum"] as? Double
                    {
                        controller.value_Cis_3rd = inarV
                        controller.value_Inar_3rd =  cisV - inarV

                        let perc = (inarV/cisV) * 100
                        controller.str_innerHolePercentage_3rd = "\(perc.rounded(toPlaces: 1)) %"
                    }
                }
                
                /*
                if let strPerc:String = inarDict["performance_str"] as? String
                {
                    controller.str_innerHolePercentage_Kpi = strPerc
                }
                */
                if let inarD:String = inarDict["unefon_sales_sum_str"] as? String
                {
                    controller.str_InarDisplay_Act = inarD
                }
                if let cisD:String = inarDict["att_sales_sum_str"] as? String
                {
                    controller.str_InarDisplay_Kpi = cisD
                }
                if let inarD:String = inarDict["sales_sum_str"] as? String
                {
                    controller.str_InarDisplay_3rd = inarD
                }
            }
            
            controller.view.frame = cell.viewParent.bounds;
            controller.willMove(toParent: self)
            cell.viewParent.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            break
        case 3:
            // Bar chart
            
            cell.viewParent.layer.borderWidth = 0.6
            
            let controller: VSBarChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "VSBarChartVC_ID") as! VSBarChartVC
            
            if let aBar:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                controller.arrBars_InCollection = aBar
               // print(aBar)
            }
            
            controller.view.frame = cell.viewParent.bounds;
            controller.willMove(toParent: self)
            cell.viewParent.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            
            break
        case 4:
            // grid 3
            
            if let d6:[String:Any] = dict["data"] as? [String:Any]
            {
                if let arrFir:[[String:Any]] = d6["headers"] as? [[String:Any]]
                {
                    if let arrRest:[[[String:Any]]] = d6["content"] as? [[[String:Any]]]
                    {
                        
                        let controller: GridVC = AppStoryBoards.Customs.instance.instantiateViewController(withIdentifier: "GridVC_ID") as! GridVC
                        controller.arrFirstSection = arrFir
                        controller.useValue_ForAllCollScrollsHorz = 3
                        controller.arrMain = arrRest
                        controller.view.frame = cell.viewParent.bounds;
                        controller.willMove(toParent: self)
                        cell.viewParent.addSubview(controller.view)
                        self.addChild(controller)
                        controller.didMove(toParent: self)
                    }
                }
            }
            
            break
        default:
            break
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
        return 0.0
    }
    
    override func viewWillLayoutSubviews() {
        collView.reloadData() // this will reload the collV in each orientation then set size
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = self.collView.frame.size.width
        
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        {
            // Portrait
            switch indexPath.item
            {
            case 0:
                // grid 1
                return CGSize(width: width/1.1, height: 250)
            case 1:
                // grid 2
                return CGSize(width: width/1.1, height: 250)
            case 2:
                // pie chart
                return CGSize(width: width/1.1, height: 290)
            case 3:
                // Bar chart
                return CGSize(width: width/1.1, height: 290)
            case 4:
                // grid 3
                return CGSize(width: width/1.1, height: 350)
            default:
                break
            }
        }
        else
        {
            // Landscape
            switch indexPath.item
            {
            case 0:
                // grid 1
                return CGSize(width: width, height: 250)
            case 1:
                // grid 2
                return CGSize(width: width, height: 250)
            case 2:
                // pie chart
                return CGSize(width: width/2.0, height: 290)
            case 3:
                // Bar chart
                return CGSize(width: width/2.0, height: 290)
            case 4:
                // grid 3
                return CGSize(width: width, height: 350)
            default:
                break
            }
        }
        return CGSize(width: 0, height: 0)
    }
}
