//
//  GridVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 9/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class GridVC: UIViewController {
    
    @IBOutlet weak var table1:UITableView!
    @IBOutlet weak var table2:UITableView!
    @IBOutlet weak var viewBk:UIView!
    
    @IBOutlet weak var c_tbl1_Wd:NSLayoutConstraint!
    
    var checkSpecialCase_DIS = false
    var checkSpecialCase_PO = false
    
    var arrFirstSection:[[String:Any]] = []
    
    var arrMain: [[[String:Any]]] = []{
        didSet{
            self.reloadGrid()
        }
    }
    var arrToPass: [[[String:Any]]] = []
    var header1CollVReff:UICollectionView!
    var header2CollVReff:UICollectionView!
    
    var useValue_ForAllCollScrollsHorz:Int!
    var isShowTopBlackHeaderTitlesInCenter = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBk.layer.borderWidth = 0.6
        
        if isPad
        {
            c_tbl1_Wd.constant = 220
        }
        else
        {
            c_tbl1_Wd.constant = 90
        }
    }
    
    func reloadGrid()
    {
        if arrMain.count > 0
        {
            for index in 1..<arrMain.count
            {
                let arr: [[String:Any]] = arrMain[index]
                arrToPass.append(arr)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table1.delegate = self
        table1.dataSource = self
        table2.delegate = self
        table2.dataSource = self
        
        table1.reloadData()
        table2.reloadData()
    }
    
}

extension GridVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2 // one black other gray
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            // Its Section 1
            
            if tableView == table1 // for left table, means first column Black Header
            {
                let di:[String:Any] = arrFirstSection.first!
                
                let headerCell: CellTbl_RowHeaders = tableView.dequeueReusableCell(withIdentifier: "CellTbl_RowHeaders") as! CellTbl_RowHeaders
                headerCell.selectionStyle = .none
                headerCell.backgroundColor = UIColor.black
                
                if let str:String = di["header_name"] as? String
                {
                    headerCell.lblTitle.text = str
                    headerCell.lblTitle.textColor = .white
                }
                if let str:String = di["value"] as? String
                {
                    headerCell.lblTitle.text = str
                    headerCell.lblTitle.textColor = .white
                }
                
                if isPad == false
                {
                    // iPhone
                    headerCell.lblTitle.font = UIFont(name: CustomFont.regular, size: 12.0)
                }
                
                if checkSpecialCase_DIS == true
                {
                    headerCell.backgroundColor = UIColor.black
                    headerCell.lblTitle.textColor = .white
                }
                
                return headerCell
            }
            else
            {
                // for table 2 header view Black
                let headerCell:CellTbl_HorzRows = tableView.dequeueReusableCell(withIdentifier: "CellTbl_HorzRows") as! CellTbl_HorzRows
                headerCell.selectionStyle = .none
//                headerCell.backgroundColor = UIColor.black
                
                var arrPs:[[String:Any]] = []
                
                for index in 1..<arrFirstSection.count
                {
                    let dic:[String:Any] = arrFirstSection[index]
                    arrPs.append(dic)
                }
                
                headerCell.isTextWhite = true
                headerCell.showDownArrow = false
                headerCell.changeBkColor = false
                
                let dictP:[String:Any] = arrFirstSection.first!
                if let str:String = dictP["header_name"] as? String
                {
                    headerCell.dateInRow = str  // it's just for reference that this cell of CollV tapped
                }
                if let str:String = dictP["value"] as? String
                {
                    headerCell.dateInRow = str
                }                                
                                
                headerCell.isTopHeaderRow = false
                headerCell.arrData = arrPs  // it ll trigger didSet of CollV
                header1CollVReff = headerCell.collV
                
                headerCell.useValue_ForAllCollScrollsHorz = useValue_ForAllCollScrollsHorz
                
                if useValue_ForAllCollScrollsHorz == 1
                {
                    k_helper.reffAll_CollV_ForGrid_1.append(header1CollVReff)
                }
                else if useValue_ForAllCollScrollsHorz == 2
                {
                    k_helper.reffAll_CollV_ForGrid_2.append(header1CollVReff)
                }
                else if useValue_ForAllCollScrollsHorz == 3
                {
                    headerCell.isTopHeaderRow = true
                    headerCell.isShowTopBlackHeaderTitlesInCenter = isShowTopBlackHeaderTitlesInCenter
                    k_helper.reffAll_CollV_ForGrid_3.append(header1CollVReff)
                }
                
                
                if checkSpecialCase_DIS == true
                {
                    headerCell.backgroundColor = UIColor.black
                    headerCell.checkSpecialCase_DIS = checkSpecialCase_DIS
                    headerCell.checkSpecialCase_PO = checkSpecialCase_PO
                }
                
                return headerCell
            }
            
        }
        else
        {
            // Its Section 2
            
            let arrT:[[String:Any]] = arrMain.first!
            
            if tableView == table1 // Grey Header table 1
            {
                let headerCell: CellTbl_RowHeaders = table1.dequeueReusableCell(withIdentifier: "CellTbl_RowHeaders") as! CellTbl_RowHeaders
                headerCell.selectionStyle = .none
                headerCell.backgroundColor = UIColor.colorWithHexString("#7D7C7C") // grey 2nd section i.e header
                
                let dict:[String:Any] = arrT.first!
                if let str:String = dict["value"] as? String
                {
                    headerCell.lblTitle.text = str
                    headerCell.lblTitle.textColor = .white
                }
                
                if isPad == false
                {
                    // iPhone
                    headerCell.lblTitle.font = UIFont(name: CustomFont.regular, size: 12.0)
                }
                
                return headerCell
            }
            else
            {
                // Grey Header Table 2
                let headerCell:CellTbl_HorzRows = table2.dequeueReusableCell(withIdentifier: "CellTbl_HorzRows") as! CellTbl_HorzRows
                headerCell.selectionStyle = .none
       //         headerCell.backgroundColor = UIColor.colorWithHexString("#7D7C7C")
                
                var arrPs:[[String:Any]] = []
                
                for index in 1..<arrT.count
                {
                    let dic:[String:Any] = arrT[index]
                    arrPs.append(dic)
                }
                
                headerCell.isTextWhite = true
                headerCell.showDownArrow = true
                headerCell.changeBkColor = true  // paint collv cell color what is coming in json
                            
                if useValue_ForAllCollScrollsHorz == 3
                {
                    // for last long grid in VS dashboard
                    headerCell.showDownArrow = false
                }
                
                let dictP:[String:Any] = arrT.first!
                if let str:String = dictP["value"] as? String
                {
                    headerCell.dateInRow = str
                }
                
                headerCell.arrData = arrPs
                header2CollVReff = headerCell.collV
                
                headerCell.useValue_ForAllCollScrollsHorz = useValue_ForAllCollScrollsHorz
                
                if useValue_ForAllCollScrollsHorz == 1
                {
                    k_helper.reffAll_CollV_ForGrid_1.append(header2CollVReff)
                }
                else if useValue_ForAllCollScrollsHorz == 2
                {
                    k_helper.reffAll_CollV_ForGrid_2.append(header2CollVReff)
                }
                else if useValue_ForAllCollScrollsHorz == 3
                {
                    k_helper.reffAll_CollV_ForGrid_3.append(header2CollVReff)
                }
                
                if checkSpecialCase_DIS == true
                {
                    // for this case we need to pass 12 static color in pair of 4
                    headerCell.isSecondSection = true                    
                    headerCell.checkSpecialCase_DIS = checkSpecialCase_DIS
                    headerCell.checkSpecialCase_PO = checkSpecialCase_PO
                }
                
                return headerCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // for both Vertical Tables Rows Will be exactly same
        
        if section == 0
        {
            return 0 // as after black we directly need to show Grey header, no rows in black
        }
        else
        {
            // this is gray header and it's rows  "arrToPass.count"
            return arrToPass.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // for both Tables Rows Height Will be exactly same
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let arrT:[[String:Any]] = arrToPass[indexPath.row]
        
        if tableView == table1
        {
            let cell:CellTbl_RowHeaders = table1.dequeueReusableCell(withIdentifier: "CellTbl_RowHeaders", for: indexPath) as! CellTbl_RowHeaders
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            
            let dict:[String:Any] = arrT.first!
            
            if let str:String = dict["value"] as? String
            {
                cell.lblTitle.text = str
            }
            
            if isPad == false
            {
                // phone
                cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 12.0)
            }
            
            cell.backgroundColor = UIColor(named: "Gray Base") // for all Left table1 Rows
            
            return cell
        }
        else
        {
            let cell:CellTbl_HorzRows = table2.dequeueReusableCell(withIdentifier: "CellTbl_HorzRows", for: indexPath) as! CellTbl_HorzRows
            cell.selectionStyle = .none
            var arrPs:[[String:Any]] = []
            
            cell.showDownArrow = false
            cell.changeBkColor = true // paint all cells in collv as what color coming in json
            
            for index in 1..<arrT.count  // its 0 index i.e. first index has been assign to table1
            {
                let dic:[String:Any] = arrT[index]
                arrPs.append(dic)
            }
            
            let dictP:[String:Any] = arrT.first!
            if let str:String = dictP["value"] as? String
            {
                cell.dateInRow = str // its var, just to check row value when tap
            }
            
            cell.arrData = arrPs
            
            cell.useValue_ForAllCollScrollsHorz = useValue_ForAllCollScrollsHorz
            
            if useValue_ForAllCollScrollsHorz == 1
            {
                k_helper.reffAll_CollV_ForGrid_1.append(cell.collV)
            }
            else if useValue_ForAllCollScrollsHorz == 2
            {
                k_helper.reffAll_CollV_ForGrid_2.append(cell.collV)
            }
            else if useValue_ForAllCollScrollsHorz == 3
            {
                k_helper.reffAll_CollV_ForGrid_3.append(cell.collV)
            }
            
            //  let dictK:[String:Any] = ["index":indexPath.row, "value": cell.collV]
            
            if checkSpecialCase_DIS == true
            {
                // for this we need to set last cell back color to Pink
                cell.isSecondSection = false
                cell.checkSpecialCase_DIS = checkSpecialCase_DIS
                cell.checkSpecialCase_PO = checkSpecialCase_PO
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Index - - - - ")
        if tableView == table1
        {
            print(indexPath.row)
        }
        else
        {
            print(indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if useValue_ForAllCollScrollsHorz == 1
        {
            k_helper.reffAll_CollV_ForGrid_1.removeAll()
        }
        else if useValue_ForAllCollScrollsHorz == 2
        {
            k_helper.reffAll_CollV_ForGrid_2.removeAll()
        }
        else if useValue_ForAllCollScrollsHorz == 3
        {
            k_helper.reffAll_CollV_ForGrid_3.removeAll()
        }
        
        let arrCells:[CellTbl_HorzRows] = table2.visibleCells as! [CellTbl_HorzRows]
        
        if useValue_ForAllCollScrollsHorz == 1
        {
            k_helper.reffAll_CollV_ForGrid_1.append(header1CollVReff)
            k_helper.reffAll_CollV_ForGrid_1.append(header2CollVReff)
        }
        else if useValue_ForAllCollScrollsHorz == 2
        {
            k_helper.reffAll_CollV_ForGrid_2.append(header1CollVReff)
            k_helper.reffAll_CollV_ForGrid_2.append(header2CollVReff)
        }
        else if useValue_ForAllCollScrollsHorz == 3
        {
            k_helper.reffAll_CollV_ForGrid_3.append(header1CollVReff)
            k_helper.reffAll_CollV_ForGrid_3.append(header2CollVReff)
        }
                
        for cell in arrCells
        {
            if useValue_ForAllCollScrollsHorz == 1
            {
                k_helper.reffAll_CollV_ForGrid_1.append(cell.collV)
            }
            else if useValue_ForAllCollScrollsHorz == 2
            {
                k_helper.reffAll_CollV_ForGrid_2.append(cell.collV)
            }
            else if useValue_ForAllCollScrollsHorz == 3
            {
                k_helper.reffAll_CollV_ForGrid_3.append(cell.collV)
            }
        }
        
        /////   //////     //////      ///////  ///////
        
        if table1 == scrollView
        {
            table2.contentOffset = table1.contentOffset
        }
        else if table2 == scrollView
        {
            table1.contentOffset = table2.contentOffset
        }
    }
}
