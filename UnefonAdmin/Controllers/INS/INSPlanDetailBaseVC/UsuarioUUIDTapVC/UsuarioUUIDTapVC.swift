//
//  UsuarioUUITapVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 6/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class UsuarioUUIDTapVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!

    let arrData_Rows:[String] = ["ImageInfo", "GeneralInfo", "CollViewCount", "CollViewCount_Dropdown", "SingleBarChart", "DoubleBarChart_Semanal", "DoubleBarChart_Mensual"]
    
    var plan_id = ""
    var uuid = ""
    
    var arr_GeneralInfo:[[String:Any]] = []
    var arr_CollV:[[String:Any]] = []
    var arr_CollV_Dropdown:[[String:Any]] = []
    
    var arr_plan_months_Picker:[[String:Any]] = []
    var arr_plan_years_Picker:[String] = []
    
    var arr_SingleBar_daily_performance:[[String:Any]] = []
    var arr_DoubleBar_weekly_performance:[[String:Any]] = []
    var arr_DoubleBar_monthly_performance:[[String:Any]] = []
    
    var strHeader_Title = ""
    var strHeader_SubTitle = ""
    var strHeader_UserImage = ""
    var strHeader_Email = ""
    var strHeader_Phone = ""
    
    var strPickedDropdownToShowinTF_Counts = ""
    var strPickedDropdownToShowinTF_SingleBar = ""
    var strPickedDropdownToShowinTF_DoubleBar = ""
    var strPickedDropdownToShowinTF_DoubleBarYear = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        
        callGetDetails()
    }
    
    override func viewDidLayoutSubviews() {
        print("- - - - HANDLE ORIENTAION FRAMES HERE - - - - - - ")
        tblView.reloadData()
    }
}

extension UsuarioUUIDTapVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData_Rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let str:String = arrData_Rows[indexPath.row]
        
        if str == "ImageInfo"
        {
            return 130
        }
        else if str == "GeneralInfo"
        {
            return 250
        }
        else if str == "CollViewCount"
        {
            return 200
        }
        else if str == "CollViewCount_Dropdown"
        {
            return 200
        }
        else if str == "SingleBarChart"
        {
            return 250
        }
        else if str == "DoubleBarChart_Semanal"
        {
            return 285
        }
        else if str == "DoubleBarChart_Mensual"
        {
            return 285
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let str:String = arrData_Rows[indexPath.row]

        if str == "ImageInfo"
        {
            let cell:CellUUIDtap_Header = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Header", for: indexPath) as! CellUUIDtap_Header
            cell.selectionStyle = .none
            
            cell.lblTitle.text = strHeader_Title
            cell.lblSubtitle.text = strHeader_SubTitle
            
            cell.imgV.layer.cornerRadius = 40.0
            cell.imgV.layer.borderWidth = 0.5
            cell.imgV.layer.masksToBounds = true
            
            cell.btnEmail.layer.cornerRadius = 20.0
            cell.btnEmail.layer.masksToBounds = true
            cell.btnPhone.layer.cornerRadius = 20.0
            cell.btnPhone.layer.masksToBounds = true
            
            cell.btnBack.layer.cornerRadius = 5.0
            
            cell.btnBack.addTarget(self, action: #selector(self.backClicked), for: .touchUpInside)
            cell.btnEmail.addTarget(self, action: #selector(self.btnEmailTapped), for: .touchUpInside)
            cell.btnPhone.addTarget(self, action: #selector(self.btnPhoneTapped), for: .touchUpInside)
            
            cell.imgV.setImageUsingUrl(strHeader_UserImage)
            
            if isPad
            {
                cell.c_lblTitle_Ld.constant = 20
                cell.c_lblTitle_Wd.constant = 320
            }
            else
            {
                cell.c_lblTitle_Wd.constant = 200
                cell.c_btnBk_Wd.constant = 70
                cell.btnBack.titleLabel?.font = UIFont(name: CustomFont.semiBold, size: 12)
                cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 12)
                cell.lblSubtitle.font = UIFont(name: CustomFont.regular, size: 12)
            }
            
            return cell
        }
        else if str == "GeneralInfo"
        {
            let cell:CellUUIDtap_Containers = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Containers", for: indexPath) as! CellUUIDtap_Containers
            cell.selectionStyle = .none

            for v in cell.v_Container.subviews
            {
                v.removeFromSuperview()
            }
            
            let controller: Report_GeneralInfoCollV = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Report_GeneralInfoCollV_ID") as! Report_GeneralInfoCollV
            
            controller.arrData = self.arr_GeneralInfo
            controller.view.frame = cell.v_Container.bounds;
            controller.willMove(toParent: self)
            cell.v_Container.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            return cell
        }
        else if str == "CollViewCount"
        {
            let cell:CellUUIDtap_Containers = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Containers", for: indexPath) as! CellUUIDtap_Containers
            cell.selectionStyle = .none
            
            for v in cell.v_Container.subviews
            {
                v.removeFromSuperview()
            }
            
            let controller: Report_CollVCount = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Report_CollVCount_ID") as! Report_CollVCount
            
            controller.arrData = self.arr_CollV
            controller.view.frame = cell.v_Container.bounds;
            controller.willMove(toParent: self)
            cell.v_Container.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

            return cell
        }
        else if str == "CollViewCount_Dropdown"
        {
            let cell:CellUUIDtap_Containers = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Containers", for: indexPath) as! CellUUIDtap_Containers
            cell.selectionStyle = .none

            for v in cell.v_Container.subviews
            {
                v.removeFromSuperview()
            }
            
            let controller: Report_CollVCountDropdown = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Report_CollVCountDropdown_ID") as! Report_CollVCountDropdown
            
            controller.closure_UpdateTable = {(arr:[[String:Any]], strPickedVal:String) in
                print("- - - - - - Count DropDown CollV Updated - - - - -")
                self.arr_CollV_Dropdown = arr
                self.strPickedDropdownToShowinTF_Counts = strPickedVal
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
            
            controller.plan_id = self.plan_id
            controller.uuid = self.uuid
            controller.strPicker = self.strPickedDropdownToShowinTF_Counts
          //  print(self.arr_plan_months_Picker)
            controller.arrData = self.arr_CollV_Dropdown
            controller.arr_Picker = self.arr_plan_months_Picker
            controller.view.frame = cell.v_Container.bounds;
            controller.willMove(toParent: self)
            cell.v_Container.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

            return cell
        }
        else if str == "SingleBarChart"
        {
            let cell:CellUUIDtap_Containers = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Containers", for: indexPath) as! CellUUIDtap_Containers
            cell.selectionStyle = .none

            for v in cell.v_Container.subviews
            {
                v.removeFromSuperview()
            }
            
            let controller: Report_SingleBarChart = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Report_SingleBarChart_ID") as! Report_SingleBarChart
            
            controller.closure_UpdateTable = {(arr:[[String:Any]], strPickedVal:String) in
                print("- - - - - - Single Barchart Updated - - - - -")
                self.arr_SingleBar_daily_performance = arr
                self.strPickedDropdownToShowinTF_SingleBar = strPickedVal
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
            
            controller.plan_id = self.plan_id
            controller.uuid = self.uuid
            controller.strPicker = self.strPickedDropdownToShowinTF_SingleBar
            controller.arrData = self.arr_SingleBar_daily_performance
            controller.arr_Picker = self.arr_plan_months_Picker
            controller.view.frame = cell.v_Container.bounds;
            controller.willMove(toParent: self)
            cell.v_Container.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

            return cell
        }
        else if str == "DoubleBarChart_Semanal"
        {
            let cell:CellUUIDtap_Containers = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Containers", for: indexPath) as! CellUUIDtap_Containers
            cell.selectionStyle = .none

            for v in cell.v_Container.subviews
            {
                v.removeFromSuperview()
            }
            
            let controller: Report_DoubleBarChartSemanal = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Report_DoubleBarChartSemanal_ID") as! Report_DoubleBarChartSemanal
            
            controller.closure_UpdateTable = {(arr:[[String:Any]], strPickedVal:String) in
                print("- - - - - - Douboe Barchart Weekly Updated - - - - -")
                self.strPickedDropdownToShowinTF_DoubleBar = strPickedVal
                self.arr_DoubleBar_weekly_performance = arr
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
            
            controller.plan_id = self.plan_id
            controller.uuid = self.uuid
            controller.strPicker = self.strPickedDropdownToShowinTF_DoubleBar
            controller.arrData = self.arr_DoubleBar_weekly_performance
            controller.arr_Picker = self.arr_plan_months_Picker
            controller.view.frame = cell.v_Container.bounds;
            controller.willMove(toParent: self)
            cell.v_Container.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

            return cell
        }
        else if str == "DoubleBarChart_Mensual"
        {
            let cell:CellUUIDtap_Containers = tableView.dequeueReusableCell(withIdentifier: "CellUUIDtap_Containers", for: indexPath) as! CellUUIDtap_Containers
            cell.selectionStyle = .none
            
            for v in cell.v_Container.subviews
            {
                v.removeFromSuperview()
            }
            
            let controller: Report_DoubleBarChartMensual = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Report_DoubleBarChartMensual_ID") as! Report_DoubleBarChartMensual
            
            controller.closure_UpdateTable = {(arr:[[String:Any]], strPickedVal:String) in
                print("- - - - - - Douboe Barchart Month Updated - - - - -")
                self.arr_DoubleBar_monthly_performance = arr
                self.strPickedDropdownToShowinTF_DoubleBarYear = strPickedVal
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
            
            controller.plan_id = self.plan_id
            controller.uuid = self.uuid
            controller.strPicker = self.strPickedDropdownToShowinTF_DoubleBarYear
            controller.arrData = self.arr_DoubleBar_monthly_performance
            controller.arr_Picker = self.arr_plan_years_Picker
            controller.view.frame = cell.v_Container.bounds;
            controller.willMove(toParent: self)
            cell.v_Container.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension UsuarioUUIDTapVC
{
    func callGetDetails()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "uuid":uuid]
        WebService.requestService(url: ServiceName.GET_UUIDtapUsuario.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
           //     print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.setUpDataWith(diMain: dict)
                            
                            /** TESTING
                            let testJson:[String:Any] = self.readJSONfromBundle(name: "uuidTapped")!
                            
                            if let diM:[String:Any] = testJson["response_object"] as? [String:Any]
                            {
                                self.setUpDataWith(diMain: diM)
                            }
                            */
                        }
                    }
                }
            }
        }
    }
    
    func setUpDataWith(diMain:[String:Any])
    {
        if let str:String = diMain["workplace_name"] as? String
        {
            self.strHeader_Title = str
        }
        if let str:String = diMain["full_name"] as? String
        {
            self.strHeader_SubTitle = str
        }
        if let str:String = diMain["profile_picture_url"] as? String
        {
            self.strHeader_UserImage = str
        }
        if let str:String = diMain["personal_mail_address"] as? String
        {
            self.strHeader_Email = str
        }
        if let str:String = diMain["phone_number"] as? String
        {
            self.strHeader_Phone = str
        }
        
        self.arr_GeneralInfo.removeAll()
        
        if let str:String = diMain["company_id"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"No.Deudor"])
        }
        if let str:String = diMain["uuid"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"UUID"])
        }
        if let str:String = diMain["personal_mail_address"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"Correo Electrónico"])
        }
        if let str:String = diMain["system_mail_address"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"Bandeja"])
        }
        if let str:String = diMain["residence_state_name"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"Estado de Residencia"])
        }
        if let str:String = diMain["campaign_name"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"Campaña"])
        }
        if let str:String = diMain["registration_date_str"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"Fecha de Registo"])
        }
        if let str:String = diMain["active_status_str"] as? String
        {
            self.arr_GeneralInfo.append(["title":str, "label":"Status"])
        }
        
        self.arr_CollV.removeAll()
        
        if let str:String = diMain["balance_str"] as? String
        {
            self.arr_CollV.append(["title":str, "label":"Puntos Obtenidos"])
        }
        if let str:String = diMain["redeemed_points_str"] as? String
        {
            self.arr_CollV.append(["title":str, "label":"Puntos Redimidos"])
        }
        if let str:String = diMain["accumulated_points_str"] as? String
        {
            self.arr_CollV.append(["title":str, "label":"Saldo Actual"])
        }
        
        self.arr_CollV_Dropdown.removeAll()

        if let di:[String:Any] = diMain["monthly_results"] as? [String:Any]
        {
            if let str:String = di["sales_quantity_str"] as? String
            {
                self.arr_CollV_Dropdown.append(["title":str, "label":"Activaciones"])
            }
            if let str:String = di["kpi_quantity_str"] as? String
            {
                self.arr_CollV_Dropdown.append(["title":str, "label":"KPI"])
            }
            if let str:String = di["performance_str"] as? String
            {
                self.arr_CollV_Dropdown.append(["title":str, "label":"Logro"])
            }
            if let str:String = di["obtained_points_str"] as? String
            {
                self.arr_CollV_Dropdown.append(["title":str, "label":"Puntos Obtenidos"])
            }
        }
        
        self.arr_plan_months_Picker.removeAll()

        if let ar:[[String:Any]] = diMain["plan_months"] as? [[String:Any]]
        {
            self.arr_plan_months_Picker = ar
        }
        
        self.arr_plan_years_Picker.removeAll()
        
        if let ar:[String] = diMain["plan_years"] as? [String]
        {
            self.arr_plan_years_Picker = ar
        }
        
        self.arr_SingleBar_daily_performance.removeAll()
        
        if let di:[String:Any] = diMain["daily_performance"] as? [String:Any]
        {
            if let ar:[[String:Any]] = di["values"] as? [[String:Any]]
            {
                self.arr_SingleBar_daily_performance = ar
            }
        }
        
        self.arr_DoubleBar_weekly_performance.removeAll()
        
        if let di:[String:Any] = diMain["weekly_performance"] as? [String:Any]
        {
            if let ar:[[String:Any]] = di["values"] as? [[String:Any]]
            {
                self.arr_DoubleBar_weekly_performance = ar
            }
        }
        
        self.arr_DoubleBar_monthly_performance.removeAll()
        
        if let di:[String:Any] = diMain["monthly_performance"] as? [String:Any]
        {
            if let ar:[[String:Any]] = di["values"] as? [[String:Any]]
            {
                self.arr_DoubleBar_monthly_performance = ar
            }
        }
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

extension UsuarioUUIDTapVC
{
    @objc func btnEmailTapped()
    {
        if let url = URL(string: "mailto:\(strHeader_Email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func btnPhoneTapped()
    {
        let url: NSURL = URL(string: "TEL://\(strHeader_Phone)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @objc func backClicked()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
