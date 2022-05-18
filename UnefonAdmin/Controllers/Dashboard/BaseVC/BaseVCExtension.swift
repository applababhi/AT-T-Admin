//
//  BaseVCExtension.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 9/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import Foundation

// Call Apis

extension BaseVC
{
    func callAPIToLoadDashBoardFor(strDashboardName:String, payload:[String:Any])
    {
        var dictForParam:[String:Any] = payload
        var serviceName = ""
        
        if strDashboardName == "VS"
        {
            serviceName = ServiceName.POST_getVSreport.rawValue
        }
        else if strDashboardName == "ACT"
        {
            dictForParam["product_id"] = "INAR"  // For Default call (ACTIVACIONES CIS)
            serviceName = ServiceName.POST_getACTreport.rawValue
        }
        else if strDashboardName == "DIS"
        {
            serviceName = ServiceName.POST_getDISreport.rawValue
        }
        else if strDashboardName == "PO"
        {
            self.setBaseViewContainer(str: self.selectedDashboardName, resetFilter: false, callNotificationToGetSameFilterDict: false, dict2Pas: [:])
            return
        }
        else if strDashboardName == "INS"
        {
            self.setBaseViewContainer(str: self.selectedDashboardName, resetFilter: false, callNotificationToGetSameFilterDict: false, dict2Pas: [:])
            return
        }
        else if strDashboardName == "COB"
        {
            self.setBaseViewContainer(str: self.selectedDashboardName, resetFilter: false, callNotificationToGetSameFilterDict: false, dict2Pas: [:])
            return
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dictForParam
        //   print(param)
        WebService.requestService(url: serviceName, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
               //  print(jsonString)
            
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
                            if let di:[String:Any] = json["response_object"] as? [String:Any]
                            {
                                if self.selectedDashboardName == "ACT"
                                {
                                    // here i am adding Filter Dic in dict2Pas, because i need to tk this selected filters payload to ACT VC for header selections Api calls
                                    let dictPass:[String:Any] = ["filter":dictForParam, "response":di]
                                    self.setBaseViewContainer(str: self.selectedDashboardName, resetFilter: false, callNotificationToGetSameFilterDict: false, dict2Pas: dictPass)
                                }
                                else
                                {
                                    self.setBaseViewContainer(str: self.selectedDashboardName, resetFilter: false, callNotificationToGetSameFilterDict: false, dict2Pas: di)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiPushToken()
    {
        var userId = ""
        if let uuid:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            if uuid != ""
            {
                userId = uuid
            }
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["ios_notification_token":deviceToken_FCM, "supervisor_id": userId]
        //   print(param)
        WebService.requestService(url: ServiceName.PUT_updateDeviceToken.rawValue, method: .put, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            // print(jsonString)
            
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
                            print("- - - - - - -")
                            print(msg)
                            print(" - - Push Token Updated ")
                            
                            //  self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        DispatchQueue.main.async {
                            if let dict:[String:Any] = json["response_object"] as? [String:Any]
                            {
                                print("- - - - - - -")
                                print(dict)
                                print(" - - Push Token Updated")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callApiDeletePushToken()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["ios_notification_token":deviceToken_FCM]
        //  print(param)
        WebService.requestService(url: ServiceName.PUT_deleteDeviceToken.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            if let dict:[String:Any] = json["response_object"] as? [String:Any]
                            {
                                k_userDef.setValue("", forKey: userDefaultKeys.user_Loginid.rawValue)
                                k_userDef.synchronize()
                                
                                let vc: LoginVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "LoginVC_ID") as! LoginVC
                                k_window.rootViewController = vc
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func callGetFilter_JustForRedUpdateLabelChange()
    {
        var strName = ""
        
        if let str:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            strName = str
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["supervisor_id":strName]
        WebService.requestService(url: ServiceName.GET_GetFilter.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                if let dicy:[String:Any] = json["response_object"] as? [String:Any]
                {
                    if let strUpdate:String = dicy["last_updated_str"] as? String
                    {
                        k_helper.lastUpdateLabel = strUpdate
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lastUpdateLabel"), object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
    
}
