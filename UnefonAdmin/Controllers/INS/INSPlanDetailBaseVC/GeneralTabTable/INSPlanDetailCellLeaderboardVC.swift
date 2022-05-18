//
//  INSPlanDetailCellLeaderboardVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 29/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class INSPlanDetailCellLeaderboardVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }

}

extension INSPlanDetailCellLeaderboardVC: UITableViewDataSource, UITableViewDelegate
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
        let headerCell: CellINSLeaderboard_Header = tableView.dequeueReusableCell(withIdentifier: "CellINSLeaderboard_Header") as! CellINSLeaderboard_Header
        headerCell.selectionStyle = .none
        
        if isPad == false
        {
            headerCell.lblDashboard.font = UIFont(name: CustomFont.regular, size: 13)
            headerCell.lblAct.font = UIFont(name: CustomFont.regular, size: 13)
            headerCell.lblLorgo.font = UIFont(name: CustomFont.regular, size: 13)
            
            headerCell.c_lblAct_Wd.constant = 90
            headerCell.c_lblLorgo_Wd.constant = 90
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
        
        let cell:CellINSLeaderboard_Rows = tableView.dequeueReusableCell(withIdentifier: "CellINSLeaderboard_Rows", for: indexPath) as! CellINSLeaderboard_Rows
        cell.selectionStyle = .none
        
        if let str:String = d["sales_quantity_str"] as? String
        {
            cell.lbl_Activa.text = str
        }
        if let str:String = d["performance_str"] as? String
        {
            cell.lbl_Percent.text = str
        }
        if let str:Int = d["position"] as? Int
        {
            cell.lbl_Position.text = "\(str)"
        }
        if let str:String = d["workplace_name"] as? String
        {
            cell.lbl_Distributor.text = str
        }
        
        if isPad == false
        {
            cell.lbl_Distributor.font = UIFont(name: CustomFont.regular, size: 10)
            cell.lbl_Activa.font = UIFont(name: CustomFont.regular, size: 12)
            cell.lbl_Percent.font = UIFont(name: CustomFont.regular, size: 12)
            
            cell.c_lblAct_Wd.constant = 90
            cell.c_lblLorgo_Wd.constant = 90
        }


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}
