//
//  INSUsuarioGridVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 5/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class INSUsuarioGridVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    var arrData:[[String:Any]] = []
    var dictHeader:[String:Any] = [:]
    
    var closure_UUIDTapped: (String)->() = {(uuidTapped:String) in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictHeader = ["company_id" : "No. Deudor", "workplace_name" : "Distribuidor", "sales_quantity_str": "Activaciones", "sales_kpi_str": "KPI", "performance_str": "% Logro", "balance_str": "Saldo Actual", "accumulated_points_str":"Puntos Obtenidos"]

        if arrData.count > 0
        {
            tblView.delegate = self
            tblView.dataSource = self
            tblView.reloadData()
        }
    }

}

extension INSUsuarioGridVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // Header
        let headerCell: Cell_INSUsuarioHeader = tableView.dequeueReusableCell(withIdentifier: "Cell_INSUsuarioHeader") as! Cell_INSUsuarioHeader
        headerCell.selectionStyle = .none

        headerCell.lbl1.text = ""
        headerCell.lbl2.text = ""
        headerCell.lbl3.text = ""
        headerCell.lbl4.text = ""
        headerCell.lbl5.text = ""
        headerCell.lbl6.text = ""
        headerCell.lbl7.text = ""

        headerCell.lbl1.backgroundColor = .clear
        headerCell.lbl2.backgroundColor = .clear
        headerCell.lbl3.backgroundColor = .clear
        headerCell.lbl4.backgroundColor = .clear
        headerCell.lbl5.backgroundColor = .clear
        headerCell.lbl6.backgroundColor = .clear
        headerCell.lbl7.backgroundColor = .clear

        headerCell.v_Indicator.backgroundColor = .clear
        headerCell.v_1.backgroundColor = .clear
        
        headerCell.v_Indicator.layer.cornerRadius = 7.0
        headerCell.v_Indicator.layer.masksToBounds = true
        
        if let str:String = dictHeader["company_id"] as? String
        {
            headerCell.lbl1.text = str
        }
        if let str:String = dictHeader["workplace_name"] as? String
        {
            headerCell.lbl2.text = str
        }
        if let str:String = dictHeader["sales_quantity_str"] as? String
        {
            headerCell.lbl3.text = str
        }
        if let str:String = dictHeader["sales_kpi_str"] as? String
        {
            headerCell.lbl4.text = str
        }
        if let str:String = dictHeader["performance_str"] as? String
        {
            headerCell.lbl5.text = str
        }
        if let str:String = dictHeader["balance_str"] as? String
        {
            headerCell.lbl6.text = str
        }
        if let str:String = dictHeader["accumulated_points_str"] as? String
        {
            headerCell.lbl7.text = str
        }
        
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
        {
            // 840, 840-25 = 815/7 = 116.4
            headerCell.c_lbl1_Wd.constant = 116.4
            headerCell.c_lbl2_Wd.constant = 232.80 // (116.4 * 2)
            headerCell.c_lbl3_Wd.constant = 116.4
            headerCell.c_lbl4_Wd.constant = 58.20
            headerCell.c_lbl5_Wd.constant = 58.20
            headerCell.c_lbl6_Wd.constant = 116.4
            headerCell.c_lbl7_Wd.constant = 116.4

        }
        else
        {
            // 670, 670-25(circleview) = 645/7 = 92.10
            headerCell.c_lbl1_Wd.constant = 92.10
            headerCell.c_lbl2_Wd.constant = 184.20 // (92.10 * 2)
            headerCell.c_lbl3_Wd.constant = 92.10
            headerCell.c_lbl4_Wd.constant = 46.05
            headerCell.c_lbl5_Wd.constant = 66.05
            headerCell.c_lbl6_Wd.constant = 72.10
            headerCell.c_lbl7_Wd.constant = 92.10
            
            if isPad == false
            {
                // 350
                headerCell.c_lbl1_Wd.constant = 50
                headerCell.c_lbl2_Wd.constant = 50
                headerCell.c_lbl3_Wd.constant = 50
                headerCell.c_lbl4_Wd.constant = 50
                headerCell.c_lbl5_Wd.constant = 50
                headerCell.c_lbl6_Wd.constant = 50
                headerCell.c_lbl7_Wd.constant = 50
                
                headerCell.lbl1.font = UIFont(name: CustomFont.regular, size: 6.0)
                headerCell.lbl2.font = UIFont(name: CustomFont.regular, size: 6.0)
                headerCell.lbl3.font = UIFont(name: CustomFont.regular, size: 6.0)
                headerCell.lbl4.font = UIFont(name: CustomFont.regular, size: 6.0)
                headerCell.lbl5.font = UIFont(name: CustomFont.regular, size: 6.0)
                headerCell.lbl6.font = UIFont(name: CustomFont.regular, size: 6.0)
                headerCell.lbl7.font = UIFont(name: CustomFont.regular, size: 6.0)
            }
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let d:[String:Any] = arrData[indexPath.row]
        
        let cell:Cell_INSUsuarioRows = tableView.dequeueReusableCell(withIdentifier: "Cell_INSUsuarioRows", for: indexPath) as! Cell_INSUsuarioRows
        cell.selectionStyle = .none
        
        cell.lbl1.text = ""
        cell.lbl2.text = ""
        cell.lbl3.text = ""
        cell.lbl4.text = ""
        cell.lbl5.text = ""
        cell.lbl6.text = ""
        cell.lbl7.text = ""
        
        cell.lbl1.textColor = .white
        cell.lbl2.textColor = .darkGray
        cell.lbl3.textColor = .darkGray
        cell.lbl4.textColor = .darkGray
        cell.lbl5.textColor = .darkGray
        cell.lbl6.textColor = .darkGray
        cell.lbl7.textColor = .darkGray

        cell.lbl1.backgroundColor = .black
        cell.lbl2.backgroundColor = .clear
        cell.lbl3.backgroundColor = .clear
        cell.lbl4.backgroundColor = .clear
        cell.lbl5.backgroundColor = .clear
        cell.lbl6.backgroundColor = .clear
        cell.lbl7.backgroundColor = .clear
        
        cell.contentView.backgroundColor = .white
        
        cell.v_Indicator.backgroundColor = .clear
        cell.v_1.backgroundColor = .clear

        cell.v_Indicator.layer.cornerRadius = 7.0
        cell.v_Indicator.layer.masksToBounds = true
        
        if let str:String = d["company_id"] as? String
        {
            cell.lbl1.text = str
        }
        if let str:String = d["workplace_name"] as? String
        {
            cell.lbl2.text = str
        }
        if let str:String = d["sales_quantity_str"] as? String
        {
            cell.lbl3.text = str
        }
        if let str:String = d["sales_kpi_str"] as? String
        {
            cell.lbl4.text = str
        }
        if let str:String = d["performance_str"] as? String
        {
            cell.lbl5.text = str
        }
        if let str:String = d["balance_str"] as? String
        {
            cell.lbl6.text = str
        }
        if let str:String = d["accumulated_points_str"] as? String
        {
            cell.lbl7.text = str
        }
        
        if isPad == true
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
            {
                // 840, 840-25 = 815/7 = 116.4
                cell.c_lbl1_Wd.constant = 116.4
                cell.c_lbl2_Wd.constant = 232.80 // (116.4 * 2)
                cell.c_lbl3_Wd.constant = 116.4
                cell.c_lbl4_Wd.constant = 58.20
                cell.c_lbl5_Wd.constant = 58.20
                cell.c_lbl6_Wd.constant = 116.4
                cell.c_lbl7_Wd.constant = 116.4

            }
            else
            {
                // 670, 670-25(circleview) = 645/7 = 92.10
                cell.c_lbl1_Wd.constant = 92.10
                cell.c_lbl2_Wd.constant = 184.20 // (92.10 * 2)
                cell.c_lbl3_Wd.constant = 92.10
                cell.c_lbl4_Wd.constant = 46.05
                cell.c_lbl5_Wd.constant = 66.05
                cell.c_lbl6_Wd.constant = 72.10
                cell.c_lbl7_Wd.constant = 92.10
            }
            
        }
        else
        {
            // Phone
            // 350
            cell.c_lbl1_Wd.constant = 50
            cell.c_lbl2_Wd.constant = 50
            cell.c_lbl3_Wd.constant = 50
            cell.c_lbl4_Wd.constant = 50
            cell.c_lbl5_Wd.constant = 50
            cell.c_lbl6_Wd.constant = 50
            cell.c_lbl7_Wd.constant = 50
            
            cell.lbl1.font = UIFont(name: CustomFont.regular, size: 8.0)
            cell.lbl2.font = UIFont(name: CustomFont.regular, size: 8.0)
            cell.lbl3.font = UIFont(name: CustomFont.regular, size: 8.0)
            cell.lbl4.font = UIFont(name: CustomFont.regular, size: 8.0)
            cell.lbl5.font = UIFont(name: CustomFont.regular, size: 8.0)
            cell.lbl6.font = UIFont(name: CustomFont.regular, size: 6.0)
            cell.lbl7.font = UIFont(name: CustomFont.regular, size: 8.0)

        }

        if let check:Bool = d["pointer_value"] as? Bool
        {
            if check == true
            {
                if let str:String = d["pointer_color"] as? String
                {
                    cell.v_Indicator.backgroundColor = UIColor.colorWithHexString(str)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let d:[String:Any] = arrData[indexPath.row]
        if let uuid:String = d["uuid"] as? String
        {
            closure_UUIDTapped(uuid)
        }
    }
}
