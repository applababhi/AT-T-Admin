//
//  FilterExtension.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 8/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import Foundation
import UIKit

extension FilterVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tblArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let d:[String:Any] = tblArray[section]
        
        if let str:String = d["section"] as? String
        {
            if str == "Filtrar por Región"
            {
                return 75
            }
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellFilter_SectionTitle = tableView.dequeueReusableCell(withIdentifier: "CellFilter_SectionTitle") as! CellFilter_SectionTitle
        headerCell.selectionStyle = .none
        headerCell.lblTitle.text = ""
        headerCell.btnSelectAll.isHidden = true
        headerCell.backgroundColor = .black //UIColor(named: "Purple")
        
        let d:[String:Any] = tblArray[section]
        
        if let str:String = d["section"] as? String
        {
            headerCell.lblTitle.text = str
            
            if str == "Filtrar por Región"
            {
                headerCell.btnSelectAll.isHidden = false
            }
        }
        
        headerCell.btnSelectAll.addTarget(self, action: #selector(self.btnSelectAllHeaderClick(btn:)), for: .touchUpInside)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let d:[String:Any] = tblArray[section]
        if let arr:[[String:Any]] = d["data"] as? [[String:Any]]
        {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let d:[String:Any] = tblArray[indexPath.section]
        let arr:[[String:Any]] = d["data"] as! [[String:Any]]
        
        if indexPath.section == 2
        {
            // Channel

            let di:[String:Any] = arr[indexPath.row] // each dict is a combination of collV header and its row
            if let ar1:[[String:Any]] = di["channels"] as? [[String:Any]]
            {
                var totalHeight:CGFloat = 0
                totalHeight = totalHeight + CGFloat(40 + (ar1.count*42)) // 40 for collV header

                return totalHeight
            }
            return 0
        }
        else if indexPath.section == 1
        {
            // Region
            let di:[String:Any] = arr[indexPath.row] // one dict one top header view with CollectionView header and cells
            if let ar1:[[String:Any]] = di["sub_regions"] as? [[String:Any]]
            {
           //     let numberOfCollVHeaderRowsCombination:Int = ar1.count
                var totalHeight:CGFloat = 0
                
                
                totalHeight = totalHeight + CGFloat(40 + ar1.count*42) // 40 is for row header, 42 is for Each collV Header
                
                /* These commented line of code, is used when we need to show, childs of subRegions(States), there ll be no cells for collV only the Header we use here
                 
                for dk in ar1
                {
                    if ar1.count == 1
                    {
                        if let arSt:[[String:Any]] = dk["states"] as? [[String:Any]]
                        {
                             totalHeight = totalHeight + CGFloat(40 + 40 + (arSt.count*42)) // 40 for row header, 40 for collV header
                        }
                    }
                    else
                    {
                        if let arSt:[[String:Any]] = dk["states"] as? [[String:Any]]
                        {
                            totalHeight = totalHeight + CGFloat(40 + 22 + (arSt.count*42)) // 40 for row header, 22 for collV header, otherwise on 40 instead of 22, it will inc gap between channel section and region section
                        }
                    }
                }
                */
                
                return totalHeight
            }
            return 0
        }
        else
        {
            // WEEK
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let d:[String:Any] = tblArray[indexPath.section]
        let arr:[[String:Any]] = d["data"] as! [[String:Any]]
        return setTableRowCell(arr: arr, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
       
        if indexPath.section == 0
        {
            // WEEK
            var d:[String:Any] = tblArray[indexPath.section]
            var arr:[[String:Any]] = d["data"] as! [[String:Any]]
            
            var di:[String:Any] = arr[indexPath.row]
            
            if let check:Bool = di["is_selected"] as? Bool
            {
                di["is_selected"] = !check
            }
            
            arr[indexPath.row] = di
            d["data"] = arr
            tblArray[indexPath.section] = d
            
            tblView.reloadData()
        }
    }
    
    @objc func btnSelectAllHeaderClick(btn:UIButton)
    {
        // Make all checkboxes TRUE

        var d_Region:[String:Any] = tblArray[1]
        var arr_Sections:[[String:Any]] = d_Region["data"] as! [[String:Any]]
        
        for indexK in 0..<arr_Sections.count
        {
            var d_TappedRow:[String:Any] = arr_Sections[indexK]
            d_TappedRow["is_selected"] = true
            
            if let a_SubRegionT:[[String:Any]] = d_TappedRow["sub_regions"] as? [[String:Any]]
            {
                var a_SubRegion:[[String:Any]] = a_SubRegionT
                for index in 0..<a_SubRegion.count
                {
                    var dSubReg:[String:Any] = a_SubRegion[index]
                    dSubReg["is_selected"] = true
                    
                    if let a_StatesT:[[String:Any]] = dSubReg["states"] as? [[String:Any]]
                    {
                        var a_States:[[String:Any]] = a_StatesT

                        for inde in 0..<a_States.count
                        {
                            var dState:[String:Any] = a_States[inde]
                            dState["is_selected"] = true
                            
                            a_States[inde] = dState
                        }
                        dSubReg["states"] = a_States
                    }
                    a_SubRegion[index] = dSubReg
                }

                d_TappedRow["sub_regions"] = a_SubRegion
            }

            arr_Sections[indexK] = d_TappedRow
        }

     //   var d_TappedRow:[String:Any] = arr_Sections[btn.tag]
        
        

        d_Region["data"] = arr_Sections
        tblArray[1] = d_Region
        
        tblView.reloadData()
        
    }
}

extension FilterVC
{
    func setTableRowCell(arr:[[String:Any]], at indexpath:IndexPath) -> UITableViewCell
    {
        if indexpath.section == 0
        {
            // WEEK
            let di:[String:Any] = arr[indexpath.row]
            
            let cell:CellFilter_JustRow = tblView.dequeueReusableCell(withIdentifier: "CellFilter_JustRow", for: indexpath) as! CellFilter_JustRow
            cell.selectionStyle = .none
            
            cell.vCheckMark.layer.cornerRadius = 5.0
            cell.vCheckMark.layer.borderWidth = 1.4
            cell.vCheckMark.layer.borderColor = UIColor.white.cgColor
            cell.vCheckMark.layer.masksToBounds = true
            
            cell.vCheckMark.isHidden = false
            
            cell.vCheckMark.backgroundColor = .clear
            
            if let check:Bool = di["is_selected"] as? Bool
            {
                if check == true
                {
                    cell.vCheckMark.backgroundColor = UIColor(named: "customBlue")
                }
            }
            
            cell.lblTitle.text = ""
            
            if let str:String = di["name"] as? String
            {
                cell.lblTitle.text = str
            }
            
            return cell
        }
        else if indexpath.section == 1
        {
            // Region
            let di:[String:Any] = arr[indexpath.row]
            
            let cell:CellFilter_Expand = tblView.dequeueReusableCell(withIdentifier: "CellFilter_Expand", for: indexpath) as! CellFilter_Expand
            cell.selectionStyle = .none
            
      //      cell.imgViewDrop.setImageColor(color: UIColor.white)
            
            cell.vCheckMark.layer.cornerRadius = 5.0
            cell.vCheckMark.layer.borderWidth = 1.4
            cell.vCheckMark.layer.borderColor = UIColor.white.cgColor
            cell.vCheckMark.layer.masksToBounds = true
            cell.vCheckMark.backgroundColor = .clear
            
            cell.vCheckMark.isHidden = false
            
            if let check:Bool = di["is_selected"] as? Bool
            {
                if check == true
                {
                    cell.vCheckMark.backgroundColor = UIColor(named: "customBlue")
                }
            }
            
            cell.lblTitle.text = ""
            
            if let str:String = di["region_name"] as? String
            {
                cell.lblTitle.text = str
            }
            
            if let ar1:[[String:Any]] = di["sub_regions"] as? [[String:Any]]
            {
                // sub_regions  can have multiple Sections (header & rows) in coll view
                cell.arr_sub_regions = ar1
            }
            
            cell.btnArrow.tag = indexpath.row
            cell.btnArrow.addTarget(self, action: #selector(self.btnRegionMainTap(btn:)), for: .touchUpInside)
            
            cell.SubRegionTapIndex = indexpath.row
            
            cell.updateArrayClosure = {(arrUpdated:[[String:Any]], indexSection:Int) in
                self.updateSubRegionArray(arrSubReg: arrUpdated, sectionIndex: indexSection)
            }
            
            return cell
        }
        else
        {
            // Channel
            
            let cell:CellFilter_ExpandCollOnly = tblView.dequeueReusableCell(withIdentifier: "CellFilter_ExpandCollOnly", for: indexpath) as! CellFilter_ExpandCollOnly
            cell.selectionStyle = .none
            
//            cell.arr_Channels = arr // direct channel array, as it has only one tree level, can have multiple Collv Sections
            
            print(arr)
            
            let di:[String:Any] = arr[indexpath.row]
            
            cell.vCheckMark.layer.cornerRadius = 5.0
            cell.vCheckMark.layer.borderWidth = 1.4
            cell.vCheckMark.layer.borderColor = UIColor.white.cgColor
            cell.vCheckMark.layer.masksToBounds = true
            cell.vCheckMark.backgroundColor = .clear
            
            cell.vCheckMark.isHidden = true
            
            if let check:Bool = di["is_selected"] as? Bool
            {
                if check == true
                {
                    cell.vCheckMark.backgroundColor = UIColor(named: "customBlue")
                }
            }
            
            cell.lblTitle.text = ""
            
            if let str:String = di["channel_group_name"] as? String
            {
                cell.lblTitle.text = str
            }

            if let ar1:[[String:Any]] = di["channels"] as? [[String:Any]]
            {
                cell.arr_Channels = ar1
            }
            
            cell.btnArrow.tag = indexpath.row
            cell.btnArrow.addTarget(self, action: #selector(self.btnChannelMainTap(btn:)), for: .touchUpInside)
            
            cell.SubChannelTapIndex = indexpath.row
            
            cell.updateArrayClosure = {(arrUpdated:[[String:Any]], indexSection:Int) in
                
                var d_Channel:[String:Any] = self.tblArray[2]
                var arr_Ch:[[String:Any]] = d_Channel["data"] as! [[String:Any]]
                
                var d_TappedRow:[String:Any] = arr_Ch[indexSection]
                
                d_TappedRow["channels"] = arrUpdated
                
                 arr_Ch[indexSection] = d_TappedRow
                d_Channel["data"] = arr_Ch
                self.tblArray[2] = d_Channel
                
                self.tblView.reloadData()
            }
            
            return cell
        }
    }
    
    @objc func btnRegionMainTap(btn:UIButton)
    {
        // its a main row of region

        var d_Region:[String:Any] = tblArray[1]
        var arr_Sections:[[String:Any]] = d_Region["data"] as! [[String:Any]]

        var d_TappedRow:[String:Any] = arr_Sections[btn.tag]

        if let check:Bool = d_TappedRow["is_selected"] as? Bool
        {
            if check == true
            {
                // now its about to set False next, so change all inner to False selction
                
                d_TappedRow["is_selected"] = false
                
                if let a_SubRegionT:[[String:Any]] = d_TappedRow["sub_regions"] as? [[String:Any]]
                {
                    var a_SubRegion:[[String:Any]] = a_SubRegionT
                    for index in 0..<a_SubRegion.count
                    {
                        var dSubReg:[String:Any] = a_SubRegion[index]
                        dSubReg["is_selected"] = false
                        
                        if let a_StatesT:[[String:Any]] = dSubReg["states"] as? [[String:Any]]
                        {
                            var a_States:[[String:Any]] = a_StatesT

                            for inde in 0..<a_States.count
                            {
                                var dState:[String:Any] = a_States[inde]
                                dState["is_selected"] = false
                                
                                a_States[inde] = dState
                            }
                            dSubReg["states"] = a_States
                        }
                        a_SubRegion[index] = dSubReg
                    }

                    d_TappedRow["sub_regions"] = a_SubRegion
                }
            }
            else
            {
                // if it already false on Main, then set to Default which is all True
                
                d_TappedRow["is_selected"] = true
                
                var dR:[String:Any] = k_helper.defaultArray_Filter[1]
                var arrR:[[String:Any]] = dR["data"] as! [[String:Any]]
                var diR:[String:Any] = arrR[btn.tag]
                if let ar1R:[[String:Any]] = diR["sub_regions"] as? [[String:Any]]
                {
                    d_TappedRow["sub_regions"] = ar1R
                }
            }

            arr_Sections[btn.tag] = d_TappedRow

            d_Region["data"] = arr_Sections
            tblArray[1] = d_Region
            
            tblView.reloadData()
        }
    }
    
    func updateSubRegionArray(arrSubReg:[[String:Any]], sectionIndex:Int)
    {
        var d_Region:[String:Any] = tblArray[1]
        var arr_Sections:[[String:Any]] = d_Region["data"] as! [[String:Any]]
        
        var d_TappedRow:[String:Any] = arr_Sections[sectionIndex]
        d_TappedRow["sub_regions"] = arrSubReg
        d_TappedRow["is_selected"] = false
        arr_Sections[sectionIndex] = d_TappedRow
        d_Region["data"] = arr_Sections
        tblArray[1] = d_Region
        tblView.reloadData()
    }
    
    @objc func btnChannelMainTap(btn:UIButton)
    {
        print("< < Nothing to do because it don't have is_selected parameter in this level > >")
    }
}
