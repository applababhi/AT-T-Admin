//
//  ACTCustomTableVC.swift
//  UnefonAdmin
//
//  Created by Abhishek Visa on 18/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class ACTCustomTableVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    var tblArray:[[String:Any]] = []
    var dictHeader:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.dataSource = self
        tblView.delegate = self
        tblView.reloadData()
    }
}

extension ACTCustomTableVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellTblAct = tableView.dequeueReusableCell(withIdentifier: "CellTblAct") as! CellTblAct
        headerCell.selectionStyle = .none
        headerCell.lblLeft.text = ""
        headerCell.lblRight.text = ""
        headerCell.backgroundColor = UIColor.lightGray
        
        headerCell.lblLeft.textColor = .white
        headerCell.lblRight.textColor = .white
        
        if let str:String = dictHeader["left"] as? String
        {
            headerCell.lblLeft.text = str
        }
        if let str:String = dictHeader["right"] as? String
        {
            headerCell.lblRight.text = str
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tblArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let d:[String:Any] = tblArray[indexPath.row]
        let cell:CellTblAct = tableView.dequeueReusableCell(withIdentifier: "CellTblAct", for: indexPath) as! CellTblAct
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.lblLeft.text = ""
        cell.lblRight.text = ""
        cell.lblLeft.textColor = .darkGray
        cell.lblRight.textColor = .darkGray

        if let str:String = d["left"] as? String
        {
            cell.lblLeft.text = str
        }
        if let str:String = d["right"] as? String
        {
            cell.lblRight.text = str
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}
