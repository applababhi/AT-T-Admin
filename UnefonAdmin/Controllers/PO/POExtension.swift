//
//  POExtension.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 28/1/20.
//  Copyright © 2020 Shalini Sharma. All rights reserved.
//

import Foundation
import UIKit

extension POVC
{
    func callUpdateRedLabel()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        WebService.requestService(url: ServiceName.GET_GetLastUpdate.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let lastUpdateStr:String = json["response_object"] as? String
                        {
                            DispatchQueue.main.async {
                                self.callGetRegions()
                                
                                k_helper.lastUpdateLabel = lastUpdateStr
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lastUpdateLabel"), object: nil, userInfo: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetRegions()
    {
        self.arrRegion.removeAll()
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        WebService.requestService(url: ServiceName.GET_GetPORegions.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrRegion = arr
                            DispatchQueue.main.async {
                                self.callGetChannels()
                                
                                if self.arrRegion.count > 0
                                {
                                    let di:[String:Any] = self.arrRegion.first!
                                    if let str:String = di["region_name"] as? String
                                    {
                                        self.txtFldRegion.text = str
                                        
                                        if let strID:Int = di["region_id"] as? Int
                                        {
                                            self.region_id = "\(strID)"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetChannels()
    {
        self.arrChannel.removeAll()
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        WebService.requestService(url: ServiceName.GET_GetPOChannels.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
         //       print(jsonString)
            
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
                        
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            if arr.count > 0
                            {
                                let dicInt:[String:Any] = arr.first!
                                if let arrChan:[[String:Any]] = dicInt["channels"] as? [[String:Any]]
                                {
                                    self.arrChannel = arrChan
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.callGetPeriod()

                                if self.arrChannel.count > 0
                                {
                                    let di:[String:Any] = self.arrChannel.first!
                                    
                                    if let strW:String = di["channel_name"] as? String
                                    {
                                        self.txtFldChannel.text = strW
                                    }
                                    
                                    if let strID:String = di["channel_id"] as? String
                                    {
                                        self.channel_id = "\(strID)"
                                    }                                                                        
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetPeriod()
    {
        self.arrPeriod.removeAll()
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        WebService.requestService(url: ServiceName.GET_GetPOPeriod.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrPeriod = arr
                            DispatchQueue.main.async {
                                
                                if self.arrPeriod.count > 0
                                {
                                    let di:[String:Any] = self.arrPeriod.first!
                                    if let str:String = di["name"] as? String
                                    {
                                        self.txtFldPeriod.text = str
                                        
                                        if let strID:String = di["id"] as? String
                                        {
                                            self.month_id = "\(strID)"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callAPIforBuscar()
    {
        var strName = ""
        if let str:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            strName = str
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["month_id":month_id, "region_id":region_id, "channel_id":channel_id, "supervisor_id":strName]
        //  print(param)
        WebService.requestService(url: ServiceName.POST_getPOsearch.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                                self.dictMain = di
                                self.setUpGrid()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setUpGrid()
    {
        for v in vContainer.subviews
        {
            v.removeFromSuperview()
        }
        
        if let arAll:[[[String:Any]]] = dictMain["content"] as? [[[String:Any]]]
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
                
                if arRest.count == 0
                {
                    self.showAlertWithTitle(title: "ATNT", message: "No se encontraron registros, intente con una combinación diferente", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                    return
                }
                                
                let controller: GridVC = AppStoryBoards.Customs.instance.instantiateViewController(withIdentifier: "GridVC_ID") as! GridVC
                
                controller.arrFirstSection = a_First
                controller.arrMain = arRest
                
                controller.checkSpecialCase_DIS = true
                controller.checkSpecialCase_PO = true
                
                controller.isShowTopBlackHeaderTitlesInCenter = false
                controller.useValue_ForAllCollScrollsHorz = 1
                controller.view.frame = vContainer.bounds;
                controller.willMove(toParent: self)
                vContainer.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
        }
        
    }
}
