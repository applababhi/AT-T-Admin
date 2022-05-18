//
//  INSDetailBaseExtension.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 5/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import Foundation
import UIKit

extension INSPlanDetailBaseVC
{
    @objc func btnActualizar_GeneralClick(btn:UIButton)
    {
        if self.strMonth_StatusGeneral.isEmpty == true || self.strLevel_StatusGeneral.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            var monthID = ""
            var levelID = ""
            
            for dic in arrLevel
            {
                if let name:String = dic["level_name"] as? String
                {
                    if name == strLevel_StatusGeneral
                    {
                        if let stId:String = dic["level"] as? String
                        {
                            levelID = stId
                        }
                        if let stId:Int = dic["level"] as? Int
                        {
                            levelID = "\(stId)"
                        }
                    }
                }
            }

            for dic in arrMonth
            {
                if let name:String = dic["month_name"] as? String
                {
                    if name == strMonth_StatusGeneral
                    {
                        if let stId:String = dic["month_id"] as? String
                        {
                            monthID = stId
                        }
                    }
                }
            }
            
            let param:[String:Any] = [
              "level": levelID,
              "month_id": monthID,
              "plan_id": plan_id
            ]
            callLeaderboardGeneralStatus(dict: param)
        }
    }
    
    @objc func btnBuscar_USuarioClick(btn:UIButton)
    {
        var monthID = ""
        
        for dic in arrMonth
        {
            if let name:String = dic["month_name"] as? String
            {
                if name == strMonth_Usuario
                {
                    if let stId:String = dic["month_id"] as? String
                    {
                        monthID = stId
                    }
                }
            }
        }
        
        var strName = ""
        if let str:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            strName = str
        }
        
        let param:[String:Any] = [
          "company_id": self.strNum_Usuario,
          "workplace_name": self.strNombre_Usuario,
          "uuid": self.strUUID_Usuario,
          "month_id": monthID,
          "plan_id": plan_id,
          "supervisor_id":strName
        ]
       // print(param)
        callSearchApiJustToGetUUIDsforTap(dict: param)

    }
    
    func callSearchApiJustToGetUUIDsforTap(dict:[String:Any])
    {
        self.arrGrid_Usuario.removeAll()
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dict
        //  print(param)
        WebService.requestService(url: ServiceName.POST_GetINSUsuarioGridUUIDs.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        DispatchQueue.main.async {
                            if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                            {
                                self.arrGrid_Usuario = arr
                                
                                
                                /* TESTING
                                let testJson:[String:Any] = self.readJSONfromBundle(name: "sample")!
                                
                                if let arrK:[[String:Any]] = testJson["response_object"] as? [[String:Any]]
                                {
                                    self.arrGrid_Usuario = arrK
                                }
                                */
                                self.tblView.reloadData()
                            }
                            else if let _:[String:Any] = json["response_object"] as? [String:Any]
                            {
                                /* TESTING
                                let testJson:[String:Any] = self.readJSONfromBundle(name: "sample")!
                                
                                if let arrK:[[String:Any]] = testJson["response_object"] as? [[String:Any]]
                                {
                                    self.arrGrid_Usuario = arrK
                                }
                                
                                */
                                self.tblView.reloadData()
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callLeaderboardGeneralStatus(dict:[String:Any])
    {
        self.arrLeaderboard.removeAll()
        self.tblView.reloadData()
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dict
        //  print(param)
        WebService.requestService(url: ServiceName.GET_LeaderboardGeneralStatus.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
            
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
                        DispatchQueue.main.async {
                            if let dd:[String:Any] = json["response_object"] as? [String:Any]
                            {
                                if let ar:[[String:Any]] = dd["leaderboard"] as? [[String:Any]]
                                {
                                        self.arrLeaderboard = ar
                                }
                                self.tblView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

// MARK: Reports Buttons
extension INSPlanDetailBaseVC
{
    @objc func btnReport_RegistradosClick(btn:UIButton)
    {
        // Call Direct link then, Share
            
        let vc:ReportsViewVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "ReportsViewVC_ID") as! ReportsViewVC
        vc.csvFilePath = "https://inspirum-unefon-unefon-sales-monitor.azurewebsites.net/downloads/reports/registration?plan_id=\(plan_id)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnReport_PuntosClick(btn:UIButton)
    {
        if self.str_ReportPickerSelected.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            var strReportID = ""
            for d in arrReports_Picker
            {
                if let st:String = d["review_short_name"] as? String
                {
                    if self.str_ReportPickerSelected == st
                    {
                        if let id:String = d["review_id"] as? String
                        {
                            strReportID = id
                        }
                    }
                }

            }
            print(strReportID)
            
            let vc:ReportsViewVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "ReportsViewVC_ID") as! ReportsViewVC
            vc.csvFilePath = "https://inspirum-unefon-unefon-sales-monitor.azurewebsites.net/downloads/reports/review?plan_id=\(plan_id)&review_id=\(strReportID)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func btnReport_DirectorioClick(btn:UIButton)
    {
        let vc:ReportsViewVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "ReportsViewVC_ID") as! ReportsViewVC
        vc.csvFilePath = "https://inspirum-unefon-unefon-sales-monitor.azurewebsites.net/downloads/reports/directory?plan_id=\(plan_id)"
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func btnReport_SaldoClick(btn:UIButton)
    {
        let vc:ReportsViewVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "ReportsViewVC_ID") as! ReportsViewVC
        vc.csvFilePath = "https://inspirum-unefon-unefon-sales-monitor.azurewebsites.net/downloads/reports/balances?plan_id=\(plan_id)"
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
