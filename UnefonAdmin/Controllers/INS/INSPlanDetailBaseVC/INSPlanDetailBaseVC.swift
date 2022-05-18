//
//  INSPlanDetailBaseVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 28/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class INSPlanDetailBaseVC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    
    var plan_id = ""
//    let dictRows:[String:Any] = ["STATUS GENERAL":["Counts", "Dropdown", "Leaderboard"],
//                                 "USUARIOS": ["Usuarios3TF", "UsuariosButtonTF", "GridUsuarios"],
//                                 "REPORTES":["Reports_Registrados", "Reports_Puntos", "Reports_Usuarios", "Reports_Saldo"] ] // hiding "Estadísticas Generales" (Counts) from Status General Tab - 8/8/20
    
    let dictRows:[String:Any] = ["STATUS GENERAL":["Dropdown", "Leaderboard"],
                                 "USUARIOS": ["Usuarios3TF", "UsuariosButtonTF", "GridUsuarios"],
                                 "REPORTES":["Reports_Registrados", "Reports_Puntos", "Reports_Usuarios", "Reports_Saldo"] ]

    var arrData_Rows:[String] = [] // "Header" will be section
    
    var arrCounts:[[String:Any]] = []
    var arrLevel:[[String:Any]] = []
    var arrMonth:[[String:Any]] = []
    var arrLeaderboard:[[String:Any]] = []
    var arrGrid_Usuario:[[String:Any]] = []
    var arrReports_Picker:[[String:Any]] = []
    
    var strLevel_StatusGeneral = ""
    var strMonth_StatusGeneral = ""
    var strUUID_Usuario = ""
    var strNombre_Usuario = ""
    var strNum_Usuario = ""
    var strMonth_Usuario = ""
    var str_ReportPickerSelected = ""
    
    var idFromBackend_strLevel_StatusGeneral = ""
    var idFromBackend_strMonth_StatusGeneral = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  arrData_Rows = ["Counts", "Dropdown", "Leaderboard"] // hiding "Estadísticas Generales" (Counts) from Status General Tab - 8/8/20
        arrData_Rows = ["Dropdown", "Leaderboard"] // just for 1st time, without header tapped
        
        callGetDefaultStatus()
        tblView.delegate = self
        tblView.dataSource = self
    }

    @IBAction func backClicked(btn:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        print("- - - - HANDLE ORIENTAION FRAMES HERE - - - - - - ")
        tblView.reloadData()
    }
}

extension INSPlanDetailBaseVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // Header CollView
        
        let headerCell: Cell_INSPlanDetail_Header = tableView.dequeueReusableCell(withIdentifier: "Cell_INSPlanDetail_Header") as! Cell_INSPlanDetail_Header
        headerCell.selectionStyle = .none
                
        headerCell.updateCollView()
               
        headerCell.closure_UpdateString = {(strTapped:String) in
            print("Load New ROWS for this SECTION - ", strTapped)
            self.arrData_Rows.removeAll()
            self.tblView.reloadData()
            
            if let ar:[String] = self.dictRows[strTapped] as? [String]
            {
                DispatchQueue.main.async {
                    self.arrData_Rows = ar
                    self.tblView.reloadData()
                }
            }
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData_Rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let str:String = arrData_Rows[indexPath.row]
      
        if str == "Counts"
        {
            // Counts CollView (Status General Header)
            return 160
        }
        else if str == "Dropdown"
        {
            // DropDown (Status General Header)
            return 150
        }
        else if str == "Leaderboard"
        {
            // Leaderboard TableView (Status General Header)
            return 500
        }
        else if str == "Usuarios3TF"
        {
            // Usuarios3TF  (Usuarios Header)
            return 110
        }
        else if str == "UsuariosButtonTF"
        {
            // UsuariosButtonTF  (Usuarios Header)
            return 110
        }
        else if str == "GridUsuarios"
        {
            // GridUsuarios Grid (Usuarios Header)
            
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
            {
                return 470
            }
            else
            {
                return 550
            }
        }
        else if str == "Reports_Registrados"
        {
            //  (Reports Header)
            return 90
        }else if str == "Reports_Puntos"
        {
            //  (Reports Header)
            return 140
        }
        else if str == "Reports_Usuarios"
        {
            //  (Reports Header)
            return 90
        }
        else if str == "Reports_Saldo"
        {
            //  (ReportsReports Header)
            return 90
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let str:String = arrData_Rows[indexPath.row]

        if str == "Counts"
        {
            // Counts CollView (Status General Header)
            let cell:Cell_INSPlanDetail_Counts = tableView.dequeueReusableCell(withIdentifier: "Cell_INSPlanDetail_Counts", for: indexPath) as! Cell_INSPlanDetail_Counts
            cell.selectionStyle = .none

            cell.lblTitle.text = "Estadísticas Generales"
            cell.arrData = self.arrCounts
            
            return cell
        }
        else if str == "Dropdown"
        {
            // DropDown (Status General Header)
            let cell:Cell_INSPlanDetail_Dropdown = tableView.dequeueReusableCell(withIdentifier: "Cell_INSPlanDetail_Dropdown", for: indexPath) as! Cell_INSPlanDetail_Dropdown
            cell.selectionStyle = .none
            cell.txtFldLevel.text = ""
            cell.txtFldMonth.text = ""
            cell.lblTitle.text = "Ranking de Distribuidores"
  
            cell.btnNext.layer.cornerRadius = 7.0
            cell.btnNext.addTarget(self, action: #selector(self.btnActualizar_GeneralClick(btn:)), for: .touchUpInside)
            
            cell.setDelegates()
            cell.txtFldLevel.layer.cornerRadius = 5.0
            cell.txtFldLevel.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFldLevel.layer.borderWidth = 1.0
            cell.txtFldLevel.layer.masksToBounds = true
            cell.txtFldMonth.layer.cornerRadius = 5.0
            cell.txtFldMonth.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFldMonth.layer.borderWidth = 1.0
            cell.txtFldMonth.layer.masksToBounds = true
            
            cell.addLeftPaddingTo(TextField: cell.txtFldLevel)
            cell.addLeftPaddingTo(TextField: cell.txtFldMonth)
            
            cell.addRightPaddingTo(TextField: cell.txtFldLevel, imageName: "down")
            cell.addRightPaddingTo(TextField: cell.txtFldMonth, imageName: "down")
            cell.txtFldLevel.setPlaceHolderColorWith(strPH: "Nivel Plantino")
            cell.txtFldMonth.setPlaceHolderColorWith(strPH: "Junio 2019")
            
            if isPad == true
            {
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
                {
                    cell.c_Horz.constant = 20
                    cell.c_vLevel_Wd.constant = 280

                }
                else
                {
                    cell.c_Horz.constant = 20
                    cell.c_vLevel_Wd.constant = 240

                }
            }
            else
            {
                // Phone
                cell.c_Horz.constant = 5
                cell.c_vLevel_Wd.constant = 140
                cell.txtFldLevel.font = UIFont(name: CustomFont.regular, size: 14.0)
                cell.txtFldMonth.font = UIFont(name: CustomFont.regular, size: 14.0)
            }
            
            cell.closure_UpdateLevelStr = { (strLevel:String) in
                self.strLevel_StatusGeneral = strLevel
                print(" - - - - ", strLevel)
            }
            cell.closure_UpdateMonthStr = { (strMonth:String) in
                self.strMonth_StatusGeneral = strMonth
                print(" - - - - ", strMonth)
            }
            
            cell.txtFldLevel.text = self.strLevel_StatusGeneral
            cell.txtFldMonth.text = self.strMonth_StatusGeneral
            
            cell.arrLevel_Picker = arrLevel
            cell.arrMonth_Picker = arrMonth
            
            if self.strLevel_StatusGeneral == ""
            {
                if arrLevel.count > 0
                {
                    let dictLevel:[String:Any] = arrLevel.first!
                    if let st:String = dictLevel["level_name"] as? String
                    {
                        cell.txtFldLevel.text = st
                        self.strLevel_StatusGeneral = st
                    }
                }
            }
            
            if self.strMonth_StatusGeneral == ""
            {
                if arrMonth.count > 0
                {
                    let dictMo:[String:Any] = arrMonth.first!
                    if let st:String = dictMo["month_name"] as? String
                    {
                        cell.txtFldMonth.text = st
                        self.strMonth_StatusGeneral = st
                    }
                }
            }
            
            return cell
        }
        else if str == "Leaderboard"
        {
            // Leaderboard TableView (Status General Header)
            let cell:Cell_INSPlanDetail_Leaderboard = tableView.dequeueReusableCell(withIdentifier: "Cell_INSPlanDetail_Leaderboard", for: indexPath) as! Cell_INSPlanDetail_Leaderboard
            cell.selectionStyle = .none
            
            if isPad
            {
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
                {
                    cell.c_v_Wd.constant = 600
                }
                else
                {
                    cell.c_v_Wd.constant = 500
                }
            }
            else
            {
                // Phone
                cell.c_v_Wd.constant = 320
            }
            
            let vc: INSPlanDetailCellLeaderboardVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "INSPlanDetailCellLeaderboardVC_ID") as! INSPlanDetailCellLeaderboardVC
            vc.arrData = arrLeaderboard
            vc.view.frame = cell.vContainer.bounds;
            vc.willMove(toParent: self)
            cell.vContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)

            return cell
        }
        else if str == "Usuarios3TF"
        {
            // Usuarios3TF  (Usuarios Header)
            let cell:CellINSPlanDetail_Usuarios3TF = tableView.dequeueReusableCell(withIdentifier: "CellINSPlanDetail_Usuarios3TF", for: indexPath) as! CellINSPlanDetail_Usuarios3TF
                cell.selectionStyle = .none
            cell.txtFldNum.text = ""
            cell.txtFldUUID.text = ""
            cell.txtFldNombre.text = ""
            cell.lblTitle.text = "Buscar Usuarios"
                        
            cell.setDelegates()
            cell.txtFldNum.layer.cornerRadius = 5.0
            cell.txtFldNum.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFldNum.layer.borderWidth = 1.0
            cell.txtFldNum.layer.masksToBounds = true

            cell.txtFldUUID.layer.cornerRadius = 5.0
            cell.txtFldUUID.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFldUUID.layer.borderWidth = 1.0
            cell.txtFldUUID.layer.masksToBounds = true
            cell.txtFldNombre.layer.cornerRadius = 5.0
            cell.txtFldNombre.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFldNombre.layer.borderWidth = 1.0
            cell.txtFldNombre.layer.masksToBounds = true
                        
            cell.addLeftPaddingTo(TextField: cell.txtFldNum)
            cell.addLeftPaddingTo(TextField: cell.txtFldNombre)
            cell.addLeftPaddingTo(TextField: cell.txtFldUUID)
                        
            cell.txtFldNum.setPlaceHolderColorWith(strPH: "Num. Deudor")
            cell.txtFldNombre.setPlaceHolderColorWith(strPH: "Nombre")
            cell.txtFldUUID.setPlaceHolderColorWith(strPH: "UUID")
                        
            if isPad == true
            {
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
                {
                    cell.c_vNum_Wd.constant = 280
                }
                else
                {
                    cell.c_vNum_Wd.constant = 200
                }
            }
            else
            {
                // Phone
                cell.c_Horz1.constant = 3
                cell.c_Horz2.constant = 3
            }
                        
            cell.closure_UpdateUUIDStr = { (str:String) in
                self.strUUID_Usuario = str
                print(" - - - - ", str)
            }
            cell.closure_UpdateNombreStr = { (str:String) in
                self.strNombre_Usuario = str
                print(" - - - - ", str)
            }
            cell.closure_UpdateNumStr = { (str:String) in
                self.strNum_Usuario = str
                print(" - - - - ", str)
            }
                        
            cell.txtFldUUID.text = self.strUUID_Usuario
            cell.txtFldNombre.text = self.strNombre_Usuario
            cell.txtFldNum.text = self.strNum_Usuario
            
            return cell
        }
        else if str == "UsuariosButtonTF"
        {
            // UsuariosButtonTF  (Usuarios Header)
            let cell:CellINSPlanDetail_UsuariosButtonTF = tableView.dequeueReusableCell(withIdentifier: "CellINSPlanDetail_UsuariosButtonTF", for: indexPath) as! CellINSPlanDetail_UsuariosButtonTF
            cell.selectionStyle = .none
            cell.txtFldMonth.text = ""
            cell.btnNext.layer.cornerRadius = 7.0
            cell.setDelegates()

            cell.txtFldMonth.layer.cornerRadius = 5.0
            cell.txtFldMonth.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFldMonth.layer.borderWidth = 1.0
            cell.txtFldMonth.layer.masksToBounds = true
                                    
            cell.addLeftPaddingTo(TextField: cell.txtFldMonth)
            cell.addRightPaddingTo(TextField: cell.txtFldMonth, imageName: "down")
            cell.txtFldMonth.setPlaceHolderColorWith(strPH: "Junio 2019")
            
            cell.btnNext.addTarget(self, action: #selector(self.btnBuscar_USuarioClick(btn:)), for: .touchUpInside)
                                    
            if isPad == true
            {
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
                {
                    cell.c_vLevel_Wd.constant = 270
                }
                else
                {
                    cell.c_vLevel_Wd.constant = 190
                }
            }
            else
            {
                // Phone
                cell.c_vLevel_Wd.constant = 150
                cell.c_btn_Wd.constant = 100
            }
                                    
            cell.closure_UpdateMonthStr = { (strMonth:String) in
                self.strMonth_Usuario = strMonth
                print(" - - - - ", strMonth)
            }
                                    
            cell.txtFldMonth.text = self.strMonth_Usuario
            cell.arrMonth_Picker = arrMonth
                        
            return cell
        }
        else if str == "GridUsuarios"
        {
            // GridUsuarios Grid (Usuarios Header)
            let cell:Cell_INSPlanDetail_Leaderboard = tableView.dequeueReusableCell(withIdentifier: "Cell_INSPlanDetail_Leaderboard", for: indexPath) as! Cell_INSPlanDetail_Leaderboard
            cell.selectionStyle = .none
            
            for v in cell.vContainer.subviews
            {
                v.removeFromSuperview()
            }
            
            if isPad
            {
                
                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
                {
                    cell.c_v_Wd.constant = 840
                }
                else
                {
                    cell.c_v_Wd.constant = 670
                }
            }
            
            if arrGrid_Usuario.count > 0
            {
                // Initiate GRID
                let vc: INSUsuarioGridVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "INSUsuarioGridVC_ID") as! INSUsuarioGridVC
                vc.arrData = arrGrid_Usuario
                
                vc.closure_UUIDTapped = {(uuidTapped:String) in
                    
                    print("UUID TApped = = ", uuidTapped)
                    
                    DispatchQueue.main.async {
                        let vc:UsuarioUUIDTapVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "UsuarioUUIDTapVC_ID") as! UsuarioUUIDTapVC
                        vc.plan_id = self.plan_id
                        vc.uuid = uuidTapped
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                vc.view.frame = cell.vContainer.bounds;
                vc.willMove(toParent: self)
                cell.vContainer.addSubview(vc.view)
                self.addChild(vc)
                vc.didMove(toParent: self)
            }

            return cell

        }
        else if str == "Reports_Registrados"
        {
            //  (Reports Header)
            let cell:CellINSPlanDetail_Reports = tableView.dequeueReusableCell(withIdentifier: "CellINSPlanDetail_Reports", for: indexPath) as! CellINSPlanDetail_Reports
            cell.selectionStyle = .none
            cell.txtFld.text = ""
            cell.lblTitle.text = "Usuarios Registrados"
            cell.btnNext.layer.cornerRadius = 7.0
            cell.setDelegates()
            cell.c_txtF_Ht.constant = 0
            cell.c_txtF_Tp.constant = 0

            cell.txtFld.layer.cornerRadius = 5.0
            cell.txtFld.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFld.layer.borderWidth = 1.0
            cell.txtFld.layer.masksToBounds = true
                                    
            cell.addLeftPaddingTo(TextField: cell.txtFld)
            cell.addRightPaddingTo(TextField: cell.txtFld, imageName: "down")
            cell.txtFld.setPlaceHolderColorWith(strPH: "Norte")
            
            cell.btnNext.addTarget(self, action: #selector(self.btnReport_RegistradosClick(btn:)), for: .touchUpInside)
                                    
            cell.closure_UpdateStr = { (str:String) in
                print(" Reports TF - - - - ", str)
            }
            
                                    
//            cell.txtFldMonth.text = self.strMonth_Usuario
//            cell.arrMonth_Picker = arrMonth
            return cell

        }
        else if str == "Reports_Puntos"
        {
                    //  (Reports Header)
            let cell:CellINSPlanDetail_Reports = tableView.dequeueReusableCell(withIdentifier: "CellINSPlanDetail_Reports", for: indexPath) as! CellINSPlanDetail_Reports
            cell.selectionStyle = .none
            cell.txtFld.text = ""
            cell.lblTitle.text = "Cálculos de Puntos"
            cell.btnNext.layer.cornerRadius = 7.0
            cell.setDelegates()
            
            if isPad
            {
                cell.c_txtF_Wd.constant = 350
            }
            else
            {
                // Phone
                cell.c_txtF_Wd.constant = 250
                cell.txtFld.font = UIFont(name: CustomFont.regular, size: 10.0)
            }
            
            //cell.c_txtF_Ht.constant = 0
            //cell.c_txtF_Tp.constant = 0
            
            cell.arr_Picker = self.arrReports_Picker

            cell.txtFld.layer.cornerRadius = 5.0
            cell.txtFld.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFld.layer.borderWidth = 1.0
            cell.txtFld.layer.masksToBounds = true
                                            
            cell.addLeftPaddingTo(TextField: cell.txtFld)
            cell.addRightPaddingTo(TextField: cell.txtFld, imageName: "down")
            cell.txtFld.setPlaceHolderColorWith(strPH: "Review (567F9) from July 1 to July 31, 2019")
                    
            cell.btnNext.addTarget(self, action: #selector(self.btnReport_PuntosClick(btn:)), for: .touchUpInside)
                                            
            cell.closure_UpdateStr = { (str:String) in
                print(" Reports picked TF string - - - - ", str)
                self.str_ReportPickerSelected = str
            }
                                            
        //            cell.txtFldMonth.text = self.strMonth_Usuario
        //            cell.arrMonth_Picker = arrMonth
            return cell

        }
        else if str == "Reports_Usuarios"
        {
                    //  (Reports Header)
            let cell:CellINSPlanDetail_Reports = tableView.dequeueReusableCell(withIdentifier: "CellINSPlanDetail_Reports", for: indexPath) as! CellINSPlanDetail_Reports
            cell.selectionStyle = .none
            cell.txtFld.text = ""
            cell.lblTitle.text = "Directorio de Usuarios"
            cell.btnNext.layer.cornerRadius = 7.0
            cell.setDelegates()
            cell.c_txtF_Ht.constant = 0
            cell.c_txtF_Tp.constant = 0

            cell.txtFld.layer.cornerRadius = 5.0
            cell.txtFld.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFld.layer.borderWidth = 1.0
            cell.txtFld.layer.masksToBounds = true
                                            
            cell.addLeftPaddingTo(TextField: cell.txtFld)
            cell.addRightPaddingTo(TextField: cell.txtFld, imageName: "down")
            cell.txtFld.setPlaceHolderColorWith(strPH: "Norte")
                    
            cell.btnNext.addTarget(self, action: #selector(self.btnReport_DirectorioClick(btn:)), for: .touchUpInside)
                                            
            cell.closure_UpdateStr = { (str:String) in
                print(" Reports TF - - - - ", str)
            }
                                            
        //            cell.txtFldMonth.text = self.strMonth_Usuario
        //            cell.arrMonth_Picker = arrMonth
            return cell

        }
        else if str == "Reports_Saldo"
        {
                    //  (Reports Header)
            let cell:CellINSPlanDetail_Reports = tableView.dequeueReusableCell(withIdentifier: "CellINSPlanDetail_Reports", for: indexPath) as! CellINSPlanDetail_Reports
            cell.selectionStyle = .none
            cell.txtFld.text = ""
            cell.lblTitle.text = "Saldo de Usuarios"
            cell.btnNext.layer.cornerRadius = 7.0
            cell.setDelegates()
            cell.c_txtF_Ht.constant = 0
            cell.c_txtF_Tp.constant = 0

            cell.txtFld.layer.cornerRadius = 5.0
            cell.txtFld.layer.borderColor = UIColor.lightGray.cgColor
            cell.txtFld.layer.borderWidth = 1.0
            cell.txtFld.layer.masksToBounds = true
                                            
            cell.addLeftPaddingTo(TextField: cell.txtFld)
            cell.addRightPaddingTo(TextField: cell.txtFld, imageName: "down")
            cell.txtFld.setPlaceHolderColorWith(strPH: "Norte")
                    
            cell.btnNext.addTarget(self, action: #selector(self.btnReport_SaldoClick(btn:)), for: .touchUpInside)
                                            
            cell.closure_UpdateStr = { (str:String) in
                print(" Reports TF - - - - ", str)
            }
                                            
        //            cell.txtFldMonth.text = self.strMonth_Usuario
        //            cell.arrMonth_Picker = arrMonth
            return cell

        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}        
}

extension INSPlanDetailBaseVC
{
    func callGetDefaultStatus()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_GetINSplanDetail_Status.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
             //   print(jsonString)
            
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
                            self.arrCounts.removeAll()
                            
                            if let di:[String:Any] = dict["counters"] as? [String:Any]
                            {
                                if let str:String = di["registered_users_count_str"] as? String
                                {
                                    self.arrCounts.append(["count":str, "title":"Usuarios Registrados"])
                                }
                                
                                if let str:String = di["pre_registered_users_count_str"] as? String
                                {
                                    self.arrCounts.append(["count":str, "title":"Usuarios Pre-Registrados"])
                                }
                                
                                if let str:String = di["workplaces_count_str"] as? String
                                {
                                    self.arrCounts.append(["count":str, "title":"Lugares de Trabajo"])
                                }
                                
                                if let str:String = di["campaigns_count_str"] as? String
                                {
                                    self.arrCounts.append(["count":str, "title":"Campañas Activas"])
                                }
                            }
                            
                            self.arrLeaderboard.removeAll()

                            if let ar:[[String:Any]] = dict["leaderboard"] as? [[String:Any]]
                            {
                                self.arrLeaderboard = ar
                            }
                            
                            self.callGetDropdownsArray()
                        }
                    }
                }
            }
        }
    }
    
    func callGetDropdownsArray()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_GetINSplanDetail_Dropdowns.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
             //   print(jsonString)
            
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
                            self.arrLevel.removeAll()
                            self.arrMonth.removeAll()
                            
                            if let ar:[[String:Any]] = dict["levels"] as? [[String:Any]]
                            {
                                self.arrLevel = ar
                            }
                            if let ar:[[String:Any]] = dict["months"] as? [[String:Any]]
                            {
                                self.arrMonth = ar
                            }
                            
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                                
                                self.callGetReportsPickerArray()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetReportsPickerArray()
    {
        self.arrReports_Picker.removeAll()
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_GetINSdetailReportsPicker.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let ar:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrReports_Picker = ar
                        }
                    }
                }
            }
        }
    }
}
