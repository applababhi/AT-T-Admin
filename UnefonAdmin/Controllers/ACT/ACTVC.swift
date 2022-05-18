//
//  ACTVC.swift
//  UnefonAdmin
//
//  Created by Abhishek Visa on 16/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class ACTVC: UIViewController {
    
    @IBOutlet weak var lblNoData:UILabel!
    @IBOutlet weak var lblHeader_CIS:UILabel!
    @IBOutlet weak var lblHeader_INAR:UILabel!
    @IBOutlet weak var vHeader_CIS:UIView!
    @IBOutlet weak var vHeader_INAR:UIView!
    @IBOutlet weak var collView:UICollectionView!
    
    @IBOutlet weak var c_vHead1_Wd:NSLayoutConstraint!
    
    var dictFull:[String:Any] = [:]
    var dictMain:[String:Any] = [:]
    var dictSelectedFilter:[String:Any] = [:]
    var arrData:[[String:Any]] = []   // Total 13 UI Elements
    
    var check_WhichHeaderSelected = "INAR" // by default (ACTIVACIONES CIS)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        k_helper.reffAll_CollV_ForGrid_1.removeAll()
        k_helper.reffAll_CollV_ForGrid_2.removeAll()
        k_helper.reffAll_CollV_ForGrid_3.removeAll()
        
        lblHeader_CIS.textColor = UIColor(named: "customBlue")
        vHeader_CIS.backgroundColor = UIColor(named: "customBlue")
        lblHeader_INAR.textColor = .black
        vHeader_INAR.backgroundColor = .black
        
        lblHeader_CIS.text = "ACTIVACIONES INAR"
        lblHeader_INAR.text = "ACTIVACIONES EFFECTIVAS"
        
        c_vHead1_Wd.constant = 220
        
        if isPad == false
        {
            c_vHead1_Wd.constant = 120
            lblHeader_CIS.font = UIFont(name: CustomFont.regular, size: 9)
            lblHeader_INAR.font = UIFont(name: CustomFont.regular, size: 9)
        }
        
        if let d:[String:Any] = dictFull["response"] as? [String:Any]
        {
            dictMain = d
        }
        if let d:[String:Any] = dictFull["filter"] as? [String:Any]
        {
            dictSelectedFilter = d
        }
        
        collView.delegate = self
        collView.dataSource = self
        
        if dictMain.count == 0
        {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }
        
        setUpCollView()
    }
    
    @IBAction func btnHeaderCISClick(btn:UIButton)
    {
        lblHeader_CIS.textColor = UIColor(named: "customBlue")
        vHeader_CIS.backgroundColor = UIColor(named: "customBlue")
        lblHeader_INAR.textColor = .black
        vHeader_INAR.backgroundColor = .black
        
        check_WhichHeaderSelected = "INAR"
        callAPIforClickedHeader()
    }
    
    @IBAction func btnHeaderINARClick(btn:UIButton)
    {
        lblHeader_CIS.textColor = .black
        vHeader_CIS.backgroundColor = .black
        lblHeader_INAR.textColor = UIColor(named: "customBlue")
        vHeader_INAR.backgroundColor = UIColor(named: "customBlue")
        
        check_WhichHeaderSelected = "EF"
        callAPIforClickedHeader()
    }
}

extension ACTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
            
            if isPad == false
            {
                // iPhone
                cell.lblTitle.font = UIFont(name: CustomFont.semiBold, size: 14)
            }
        }
        
        for views in cell.viewParent.subviews
        {
            views.removeFromSuperview()
        }
        
        cell.viewParent.layer.borderWidth = 0.6
        
        
        switch indexPath.item
        {
        case 0:
            // grid 1
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
                        controller.useValue_ForAllCollScrollsHorz = 1
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
            // grid 3
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
                        controller.useValue_ForAllCollScrollsHorz = 3
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
        case 3:
            // Pie Chart 1 static
            
            if let a1:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                let controller: ACTPieChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTPieChartVC_ID") as! ACTPieChartVC
                controller.arrData = a1
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            
            break
            
        case 4:
            // Pie Chart 2, 2 slides
            
            if let a1:[[[String:Any]]] = dict["data"] as? [[[String:Any]]]
            {
                let controller: ACTPieChartCollvVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTPieChartCollvVC_ID") as! ACTPieChartCollvVC
                controller.arrOfArrayData = a1
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            
            break
        case 5:
            // Combined Chart 1
            
            cell.viewParent.layer.borderWidth = 0.6
            
            var arXaxis:[String] = []
            var arLine:[Int] = []
            var arBar:[Int] = []
            
            if let a3:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                for d in a3
                {
                    if let strX:String = d["date"] as? String
                    {
                        // Format
                        //  2019-09-09T00:00:00.000+0000
                        //  2019-09-25T00:00:00
                        
                        let str1 = strX.components(separatedBy: "T").first
                        let str2 = str1!.components(separatedBy: "-").last
                        
                        arXaxis.append(str2!)
                    }
                    if let line:Int = d["value1"] as? Int
                    {
                        arBar.append(line)
                    }
                    if let bar:Int = d["value2"] as? Int
                    {
                        arLine.append(bar)
                    }
                }
            }
            
            let controller: ACTCombinedChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTCombinedChartVC_ID") as! ACTCombinedChartVC
            
            controller.arr_Xaxis = arXaxis
            controller.arr_forBar =  arBar
            controller.arr_forLine = arLine
            
            controller.color1 = .darkGray
            controller.color2 = .black
            
            controller.view.frame = cell.viewParent.bounds;
            controller.willMove(toParent: self)
            cell.viewParent.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            break
        case 6:
            // Combined Chart 2
            
            cell.viewParent.layer.borderWidth = 0.6
            
            var arXaxis:[String] = []
            var arLine:[Int] = []
            var arBar:[Int] = []
            
            if let a3:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                for d in a3
                {
                    if let strX:String = d["date"] as? String
                    {
                        // Format
                        //  2019-09-09T00:00:00.000+0000
                        //  2019-09-25T00:00:00
                        
                        let str1 = strX.components(separatedBy: "T").first
                        let str2 = str1!.components(separatedBy: "-").last
                        
                        arXaxis.append(str2!)
                    }
                    if let line:Int = d["value1"] as? Int
                    {
                        arBar.append(line)
                    }
                    if let bar:Int = d["value2"] as? Int
                    {
                        arLine.append(bar)
                    }
                }
            }
            
            let controller: ACTCombinedChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTCombinedChartVC_ID") as! ACTCombinedChartVC
            
            controller.arr_Xaxis = arXaxis
            controller.arr_forBar =  arBar
            controller.arr_forLine = arLine
            
            controller.color1 = UIColor(named: "customBlue")!
            controller.color2 = .black
            
            controller.view.frame = cell.viewParent.bounds;
            controller.willMove(toParent: self)
            cell.viewParent.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            break
        case 7:
            // Combined Chart 3
            
            cell.viewParent.layer.borderWidth = 0.6
            
            var arXaxis:[String] = []
            var arLine:[Int] = []
            var arBar:[Int] = []
            
            if let a3:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                for d in a3
                {
                    if let strX:String = d["date"] as? String
                    {
                        // Format
                        //  2019-09-09T00:00:00.000+0000
                        //  2019-09-25T00:00:00
                        
                        let str1 = strX.components(separatedBy: "T").first
                        let str2 = str1!.components(separatedBy: "-").last
                        
                        arXaxis.append(str2!)
                    }
                    if let line:Int = d["value1"] as? Int
                    {
                        arBar.append(line)
                    }
                    if let bar:Int = d["value2"] as? Int
                    {
                        arLine.append(bar)
                    }
                }
            }
            
            let controller: ACTCombinedChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTCombinedChartVC_ID") as! ACTCombinedChartVC
            
            controller.arr_Xaxis = arXaxis
            controller.arr_forBar =  arBar
            controller.arr_forLine = arLine
            
            controller.color1 = UIColor(named: "Yellow")!
            controller.color2 = .gray
            
            controller.view.frame = cell.viewParent.bounds;
            controller.willMove(toParent: self)
            cell.viewParent.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            break
        case 8:
            // Custom 2 Column Table
            
            cell.viewParent.layer.borderWidth = 0.6
            var dHead2pas:[String:Any] = [:]
            var aRows2pas:[[String:Any]] = []
            if let d4:[String:Any] = dict["data"] as? [String:Any]
            {
                /*
                 // make Header Array
                 if let arHead:[[String:Any]] = d4["layout"] as? [[String:Any]]
                 {
                 for i in 0..<arHead.count
                 {
                 let d:[String:Any] = arHead[i]
                 let str = ""
                 if let s:String = d["block_id"] as? String
                 {
                 if i == 0
                 {
                 dHead2pas["left"] = s
                 }
                 if i == 1
                 {
                 dHead2pas["right"] = s
                 }
                 }
                 else
                 {
                 if i == 0
                 {
                 dHead2pas["left"] = str
                 }
                 if i == 1
                 {
                 dHead2pas["right"] = str
                 }
                 }
                 }
                 }
                 */
                
                
                
                
                
                if let arRows:[[[String:Any]]] = d4["content"] as? [[[String:Any]]]
                {
                    if arRows.count > 0
                    {
                        // make Header Array
                        
                        var dFirst:[String:Any] = [:]
                        let arFirst:[[String:Any]] = arRows.first!
                        for i in 0..<arFirst.count
                        {
                            let d:[String:Any] = arFirst[i]
                            let str = ""
                            if let s:String = d["value"] as? String
                            {
                                if i == 0
                                {
                                    dFirst["left"] = s
                                }
                                if i == 1
                                {
                                    dFirst["right"] = s
                                }
                            }
                            else
                            {
                                if i == 0
                                {
                                    dFirst["left"] = str
                                }
                                if i == 1
                                {
                                    dFirst["right"] = str
                                }
                            }
                        }
                        dHead2pas = dFirst
                        
                        
                        // make rows array
                        for index in 1..<arRows.count
                        {
                            var dEach:[String:Any] = [:]
                            
                            let ar:[[String:Any]] = arRows[index]
                            for i in 0..<ar.count
                            {
                                let d:[String:Any] = ar[i]
                                let str = ""
                                if let s:String = d["value"] as? String
                                {
                                    if i == 0
                                    {
                                        dEach["left"] = s
                                    }
                                    if i == 1
                                    {
                                        dEach["right"] = s
                                    }
                                }
                                else
                                {
                                    if i == 0
                                    {
                                        dEach["left"] = str
                                    }
                                    if i == 1
                                    {
                                        dEach["right"] = str
                                    }
                                }
                            }
                            aRows2pas.append(dEach)
                        }
                    }
                    
                    
                }
                
                let controller: ACTCustomTableVC = AppStoryBoards.ACT.instance.instantiateViewController(withIdentifier: "ACTCustomTableVC_ID") as! ACTCustomTableVC
                controller.dictHeader = dHead2pas
                controller.tblArray = aRows2pas
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
                
            }
            break
        case 9:
            // Combined Chart 2
            
            var arXaxis:[String] = []
            var arLine:[Int] = []
            var arBar:[Int] = []
            
            if let a5:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                for d in a5
                {
                    if let week:String = d["week_name"] as? String
                    {
                        if let desc:String = d["description"] as? String
                        {
                            arXaxis.append("\(week)\n\(desc)")
                        }
                    }
                    if let line:Int = d["sales"] as? Int
                    {
                        arBar.append(line)
                    }
                    if let bar:Int = d["kpi"] as? Int
                    {
                        arLine.append(bar)
                    }
                }
            }
            
            let controller: ACTCombineChart2VC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTCombineChart2VC_ID") as! ACTCombineChart2VC
            
            controller.arr_Xaxis = arXaxis
            controller.arr_forBar = arBar
            controller.arr_forLine = arLine
            
            controller.view.frame = cell.viewParent.bounds;
            controller.willMove(toParent: self)
            cell.viewParent.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            break
        case 10:
            // Horz bar chart 1
            
            if let a6:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                var arYaxis:[String] = []
                var arBar:[Int] = []
                
                for d in a6
                {
                    if let state:String = d["state_name"] as? String
                    {
                        arYaxis.append(state)
                    }
                    
                    if let bar:Int = d["sales"] as? Int
                    {
                        arBar.append(bar)
                    }
                }
                
                let controller: ACTHorizontalBarChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTHorizontalBarChartVC_ID") as! ACTHorizontalBarChartVC
                controller.arr_Yaxis = arYaxis
                controller.arr_forBar = arBar
                controller.colorBar = .gray
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            
            break
        case 11:
            // Horz bar chart 2
            if let a7:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                var arYaxis:[String] = []
                var arBar:[Int] = []
                
                for d in a7
                {
                    if let state:String = d["distributor_name"] as? String
                    {
                        arYaxis.append(state)
                    }
                    
                    if let bar:Int = d["sales"] as? Int
                    {
                        arBar.append(bar)
                    }
                }
                
                let controller: ACTHorizontalBarChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTHorizontalBarChartVC_ID") as! ACTHorizontalBarChartVC
                controller.arr_Yaxis = arYaxis
                controller.arr_forBar = arBar
                controller.colorBar = .gray
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            break
        case 12:
            // Horz bar chart 3
            if let a8:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                var arYaxis:[String] = []
                var arBar:[Int] = []
                
                for d in a8
                {
                    if let state:String = d["state_name"] as? String
                    {
                        arYaxis.append(state)
                    }
                    
                    if let bar:Int = d["sales"] as? Int
                    {
                        arBar.append(bar)
                    }
                }
                
                let controller: ACTHorizontalBarChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTHorizontalBarChartVC_ID") as! ACTHorizontalBarChartVC
                controller.arr_Yaxis = arYaxis
                controller.arr_forBar = arBar
                controller.colorBar = .black
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
            break
        case 13:
            // Horz bar chart 4
            if let a9:[[String:Any]] = dict["data"] as? [[String:Any]]
            {
                var arYaxis:[String] = []
                var arBar:[Int] = []
                
                for d in a9
                {
                    if let state:String = d["distributor_name"] as? String
                    {
                        arYaxis.append(state)
                    }
                    
                    if let bar:Int = d["sales"] as? Int
                    {
                        arBar.append(bar)
                    }
                }
                
                let controller: ACTHorizontalBarChartVC = AppStoryBoards.Charts.instance.instantiateViewController(withIdentifier: "ACTHorizontalBarChartVC_ID") as! ACTHorizontalBarChartVC
                controller.arr_Yaxis = arYaxis
                controller.arr_forBar = arBar
                controller.colorBar = .black
                controller.view.frame = cell.viewParent.bounds;
                controller.willMove(toParent: self)
                cell.viewParent.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
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
                // Grid 1
                return CGSize(width: width/1.1, height: 300)
            case 1:
                // grid 2
                return CGSize(width: width/1.1, height: 300)
                case 2:
                // grid 3
                return CGSize(width: width/1.1, height: 300)
            case 3:
                // Pie Chart 1
                return CGSize(width: width/1.1, height: 275)
            case 4:
                // Pie Chart 2
                return CGSize(width: width/1.1, height: 300)
            case 5:
                //  Combined chart 1
                return CGSize(width: width/1.1, height: 300)
            case 6:
                //  Combined chart 2
                return CGSize(width: width/1.1, height: 300)
            case 7:
                //  Combined chart 3
                return CGSize(width: width/1.1, height: 300)
            case 8:
                // Table
                return CGSize(width: width/1.1, height: 300)
            case 9:
                //  Combined chart
                return CGSize(width: width/1.1, height: 300)
            case 10:
                // Horz bar chart 1
                return CGSize(width: width/1.1, height: 300)
            case 11:
                // Horz bar chart 2
                return CGSize(width: width/1.1, height: 300)
            case 12:
                // Horz bar chart 3
                return CGSize(width: width/1.1, height: 300)
            case 13:
                // Horz bar chart 4
                return CGSize(width: width/1.1, height: 300)
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
                // Grid 1
                return CGSize(width: width/2.0, height: 300)
            case 1:
                // grid 2
                return CGSize(width: width/2.0, height: 300)
                case 2:
                // grid 3
                return CGSize(width: width/2.0, height: 300)
            case 3:
                //Pie Chart 1
                return CGSize(width: width/2.0, height: 300)
            case 4:
                // Pie Chart 2
                return CGSize(width: width/2.0, height: 300)
            case 5:
                // Combined chart 1
                return CGSize(width: width/1.01, height: 300)
            case 6:
                // Combined chart 2
                return CGSize(width: width/1.01, height: 300)
            case 7:
                // Combined chart 3
                return CGSize(width: width/1.01, height: 300)
            case 8:
                // Table
                return CGSize(width: width/2.0, height: 300)
            case 9:
                // Combined chart
                return CGSize(width: width/2.0, height: 300)
            case 10:
                // Horz bar chart 1
                return CGSize(width: width/2.0, height: 300)
            case 11:
                // Horz bar chart 2
                return CGSize(width: width/2.0, height: 300)
            case 12:
                // Horz bar chart 3
                return CGSize(width: width/2.0, height: 300)
            case 13:
                // Horz bar chart 4
                return CGSize(width: width/2.0, height: 300)
            default:
                break
            }
        }
        return CGSize(width: 0, height: 0)
    }
}
