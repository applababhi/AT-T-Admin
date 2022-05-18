//
//  ACTExtension.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 17/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import Foundation

extension ACTVC
{
    func callAPIforClickedHeader()
    {
        dictSelectedFilter["product_id"] = check_WhichHeaderSelected
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dictSelectedFilter
        //  print(param)
        WebService.requestService(url: ServiceName.POST_getACTreport.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                                self.setUpCollView()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setUpCollView()
    {
        arrData.removeAll()
        collView.reloadData()
        
        if let d2:[String:Any] = dictMain["general_sales_table"] as? [String:Any]
        {
            if let title:String = d2["table_name"] as? String
            {
                arrData.append(["title":title, "data":d2])  // Grid
            }
        }
        if let d2:[String:Any] = dictMain["att_sales_table"] as? [String:Any]
        {
            if let title:String = d2["table_name"] as? String
            {
                arrData.append(["title":title, "data":d2])  // Grid
            }
        }
        if let d2:[String:Any] = dictMain["unefon_sales_table"] as? [String:Any]
        {
            if let title:String = d2["table_name"] as? String
            {
                arrData.append(["title":title, "data":d2])  // Grid
            }
        }
        if let a1:[[String:Any]] = dictMain["general_channel_composition"] as? [[String:Any]]
        {
            arrData.append(["title":"Participación Por Canal PREPAGO", "data":a1]) // One Pie chart
        }
        if let a1:[[String:Any]] = dictMain["att_channel_composition"] as? [[String:Any]]
        {
            if let a2:[[String:Any]] = dictMain["unefon_channel_composition"] as? [[String:Any]]
            {
                arrData.append(["title":"Participación Por Canal por Empresa", "data":[a1, a2]]) // Array of Pie chart
            }
        }
        
        if let a3:[[String:Any]] = dictMain["daily_sales"] as? [[String:Any]]
        {
            // create 3 arrays for 3 different chart sections from this
            
            var arr1:[[String:Any]] = []
            var arr2:[[String:Any]] = []
            var arr3:[[String:Any]] = []
            
            for di in a3
            {
                if let str1:Int = di["general_sales"] as? Int
                {
                    if let str2:Int = di["general_kpi"] as? Int
                    {
                        if let str3:String = di["date"] as? String
                        {
                            arr1.append(["value1": str1, "value2": str2, "date":str3])
                        }
                    }
                }
                
                if let str1:Int = di["att_sales"] as? Int
                {
                    if let str2:Int = di["att_kpi"] as? Int
                    {
                        if let str3:String = di["date"] as? String
                        {
                            arr2.append(["value1": str1, "value2": str2, "date":str3])
                        }
                    }
                }
                
                if let str1:Int = di["unefon_sales"] as? Int
                {
                    if let str2:Int = di["unefon_kpi"] as? Int
                    {
                        if let str3:String = di["date"] as? String
                        {
                            arr3.append(["value1": str1, "value2": str2, "date":str3])
                        }
                    }
                }
            }
            
            // Combined Chart 3
            arrData.append(["title":"Activaciones Por Día PREPAGO", "data":arr1])
            arrData.append(["title":"Activaciones Por Día AT&T", "data":arr2])
            arrData.append(["title":"Activaciones Por Día UNEFON", "data":arr3])
        }
        
        
        if let d4:[String:Any] = dictMain["channels_table"] as? [String:Any]
        {
            if let title:String = d4["table_name"] as? String
            {
                arrData.append(["title":title, "data":d4])  // Custom 2 column TableView
            }
        }
        if let a5:[[String:Any]] = dictMain["weekly_sales_counters"] as? [[String:Any]]
        {
            arrData.append(["title":"Activaciones Prepago Por Semana", "data":a5]) // Combined Chart 2
        }
        if let a6:[[String:Any]] = dictMain["best_states"] as? [[String:Any]]
        {
            let countArr:Int = a6.count
            arrData.append(["title":"Los \(countArr) Mercados con Mejor Desempeño de Prepago", "data":a6]) // horz Bar Chart 1
        }
        if let a7:[[String:Any]] = dictMain["best_distributors"] as? [[String:Any]]
        {
            let countArr:Int = a7.count
            arrData.append(["title":"Los \(countArr) Distribuidores con Mejor Desempeño de Prepago", "data":a7]) // horz Bar Chart 2
        }
        if let a8:[[String:Any]] = dictMain["worst_states"] as? [[String:Any]]
        {
            let countArr:Int = a8.count
            arrData.append(["title":"Los \(countArr) Mercados con Menor Desempeño de Prepago", "data":a8]) // horz Bar Chart 1
        }
        if let a9:[[String:Any]] = dictMain["worst_distributors"] as? [[String:Any]]
        {
            let countArr:Int = a9.count
            arrData.append(["title":"Los \(countArr) Distribuidores con Menor Desempeño de Prepago", "data":a9]) // horz Bar Chart 2
        }
        
        collView.reloadData()
    }
    /*
     -
     - Los 7 Estados con Menor Desempeño
     - Los 7 Distribuidores con Mayor Desempeño
     -
     */
}
