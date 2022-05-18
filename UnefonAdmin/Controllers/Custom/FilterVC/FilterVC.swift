//
//  FilterVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 8/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblMonth:UILabel!
    @IBOutlet weak var viewMonth:UIView!
    @IBOutlet weak var btnFilter:UIButton!
    
    @IBOutlet weak var vCheckBox_Solo:UIView!
    @IBOutlet weak var v_CB_Solo:UIView!
    
    var dictMain:[String:Any] = [:]
    var arrAllPickers:[[String:Any]] = [] // Array Of Months Dictionaries
    var arrPicker:[String] = []  // Array of Month names only
    var pickerView : UIPickerView!
    var toolBar: UIToolbar!
    var tblArray:[[String:Any]] = [["section":"Filtrar por Semana", "data":[]], ["section":"Filtrar por Región", "data":[]], ["section":"Filtrar por Canal", "data":[]]]
    var check_SoloCheckBox = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v_CB_Solo.isHidden = true
        btnFilter.layer.cornerRadius = 6.0
        viewMonth.layer.cornerRadius = 6.0
        viewMonth.layer.borderColor = UIColor.white.cgColor
        viewMonth.layer.borderWidth = 1.5
        lblMonth.text = ""
        callGetFilter()
        
        vCheckBox_Solo.layer.cornerRadius = 5.0
        vCheckBox_Solo.layer.borderWidth = 1.4
        vCheckBox_Solo.layer.borderColor = UIColor.white.cgColor
        vCheckBox_Solo.layer.masksToBounds = true
        vCheckBox_Solo.backgroundColor = UIColor(named: "customBlue")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeVCPassOlderFilterDictDirectly_NoReset(_:)), name: Notification.Name("changeVCPassOlderFilterDictDirectly_NoReset"), object: nil)
    }
  
    @objc func changeVCPassOlderFilterDictDirectly_NoReset(_ notification: NSNotification)
    {
        print("- Call Api to upload push token - ", deviceToken_FCM)
        btnFilterClick(btn: UIButton())
    }

    @IBAction func btnFilterClick(btn:UIButton)
    {
        // Create PayLoad To Pass to BaseVC for is_selected True Values
        
        var dict2Pas:[String:Any] = [:]
        for d in arrAllPickers
        {
            if let name:String = d["name"] as? String
            {
                if lblMonth.text! == name
                {
                    if let strId:String = d["id"] as? String
                    {
                        dict2Pas["month_id"] = strId
                    }
                }
            }
        }
        
        for index in 0..<self.tblArray.count
        {
            let d_Section:[String:Any] = tblArray[index]
            
            if index == 0
            {
                // Month
                var weekSelected:[String] = []
                
                if let aWeeks:[[String:Any]] = d_Section["data"] as? [[String:Any]]
                {
                    for i in 0..<aWeeks.count
                    {
                        let di:[String:Any] = aWeeks[i]
                        if let check:Bool = di["is_selected"] as? Bool
                        {
                            if check == true
                            {
                                if let sID:String = di["id"] as? String
                                {
                                    weekSelected.append(sID)
                                }
                            }
                        }
                    }
                }
                dict2Pas["weeks"] = weekSelected
            }
            else if index == 1
            {
                // Region
                //  var stateSelected:[String] = [] // not needed states in this version
                var subRegionSelected:[String] = []
                
                if let aRegions:[[String:Any]] = d_Section["data"] as? [[String:Any]]
                {
                    //  print(aRegions)
                    for i in 0..<aRegions.count
                    {
                        let di:[String:Any] = aRegions[i]
                        
                        if let aSubRegions:[[String:Any]] = di["sub_regions"] as? [[String:Any]]
                        {
                            for k in 0..<aSubRegions.count
                            {
                                let diSub:[String:Any] = aSubRegions[k]
                                
                                if let check:Bool = diSub["is_selected"] as? Bool
                                {
                                    if check == true
                                    {
                                        if let sID:String = diSub["sub_region_id"] as? String
                                        {
                                            subRegionSelected.append(sID)
                                        }
                                        if let sID:Int = diSub["sub_region_id"] as? Int
                                        {
                                            subRegionSelected.append("\(sID)")
                                        }
                                    }
                                }
                                /*  // not needed states in this version
                                 if let aStates:[[String:Any]] = diSub["states"] as? [[String:Any]]
                                 {
                                 for m in 0..<aStates.count
                                 {
                                 let diState:[String:Any] = aStates[m]
                                 if let check:Bool = diState["is_selected"] as? Bool
                                 {
                                 if check == true
                                 {
                                 if let sID:String = diState["state_id"] as? String
                                 {
                                 stateSelected.append(sID)
                                 }
                                 if let sID:Int = diState["state_id"] as? Int
                                 {
                                 stateSelected.append("\(sID)")
                                 }
                                 }
                                 }
                                 }
                                 }
                                 */
                            }
                        }
                    }
                    //    dict2Pas["states"] = stateSelected
                    dict2Pas["sub_regions"] = subRegionSelected
                }
            }
            else if index == 2
            {
                // Channels
                var channelSelected:[String] = []
                
                if let aChannels:[[String:Any]] = d_Section["data"] as? [[String:Any]]
                {
                    for i in 0..<aChannels.count
                    {
                        let di:[String:Any] = aChannels[i]
                        
                        if let aSubChannel:[[String:Any]] = di["channels"] as? [[String:Any]]
                        {
                            for k in 0..<aSubChannel.count
                            {
                                let diSub:[String:Any] = aSubChannel[k]
                                if let check:Bool = diSub["is_selected"] as? Bool
                                {
                                    if check == true
                                    {
                                        if let sID:String = diSub["channel_id"] as? String
                                        {
                                            channelSelected.append(sID)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    dict2Pas["channels"] = channelSelected
                }
            }
        }
        
        var strName = ""
        if let str:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            strName = str
        }
        dict2Pas["supervisor_id"] = strName
        dict2Pas["only_use_accountable_sales"] = check_SoloCheckBox == true ? 1 : 0

        if v_CB_Solo.isHidden == true
        {
            dict2Pas["only_use_accountable_sales"] = 0
        }
        else
        {
            dict2Pas["only_use_accountable_sales"] = check_SoloCheckBox == true ? 1 : 0
        }
        
        
        // print("- - > ", dict2Pas)
        
        // Dismiss Filter Screen & Notify BaseVC
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filterModified"), object: nil, userInfo: dict2Pas)
    }
    
    @IBAction func btnSoloCheckboxClick(btn:UIButton)
    {
        check_SoloCheckBox = !check_SoloCheckBox
        
        vCheckBox_Solo.backgroundColor = .clear
        
        if check_SoloCheckBox == true
        {            
            vCheckBox_Solo.backgroundColor = UIColor(named: "customBlue")
        }
    }
}

extension FilterVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBAction func btnPickerClick(btn:UIButton)
    {
        showPickerView()
    }
    
    func showPickerView()
    {
        // UIPickerView
        if isPad
        {
            self.pickerView = UIPickerView(frame:CGRect(x: 0, y: UIScreen.main.bounds.size.height - 316, width: self.view.frame.size.width, height: 316))
        }
        else
        {
            self.pickerView = UIPickerView(frame:CGRect(x: 0, y: UIScreen.main.bounds.size.height - 216, width: self.view.frame.size.width, height: 216))
        }
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.colorWithHexString("#F4F4F4")
        self.view.addSubview(self.pickerView)
        
        // ToolBar
        toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: pickerView.frame.origin.y - 40, width: self.view.frame.size.width, height: 40)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([doneButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func donePickerClick() {
        pickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        updateTableArrayFromPicker()
    }
    @objc func cancelPickerClick() {
        pickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strTitle:String = arrPicker[row]
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let strTitle:String = arrPicker[row]
        lblMonth.text = strTitle
        print(strTitle)
    }
}

extension FilterVC
{
    func updateTableArrayFromPicker()
    {
        let str = lblMonth.text!
        
        var dict1:[String:Any] = ["section":"Filtrar por Semana"]
        for d in arrAllPickers
        {
            if let name:String = d["name"] as? String
            {
                if str == name
                {
                    if let arr:[[String:Any]] = d["weeks"] as? [[String:Any]]
                    {
                        dict1["data"] = arr
                    }
                }
            }
        }
        tblArray[0] = dict1
        ///////// /////  ///////  ///////
        
        tblView.reloadData()
    }
}

extension FilterVC
{
    func callGetFilter()
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
                        
                        if let dicy:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dictMain = dicy
                                                
                            if let strUpdate:String = dicy["last_updated_str"] as? String
                            {
                                k_helper.lastUpdateLabel = strUpdate
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lastUpdateLabel"), object: nil, userInfo: nil)
                            }
                            
                            if let check:Bool = dicy["display_structure_filter"] as? Bool
                            {
                                if check == true
                                {
                                    self.v_CB_Solo.isHidden = false
                                }
                            }
                            
                            if let arr:[[String:Any]] = dicy["months"] as? [[String:Any]]
                            {
                                self.arrAllPickers = arr
                                self.setupPicker()
                            }
                            
                            if let arr:[[String:Any]] = dicy["regions"] as? [[String:Any]]
                            {
                                var dict1:[String:Any] = ["section":"Filtrar por Semana"]
                                
                                let d:[String:Any] = self.arrAllPickers.first!
                                if let arr:[[String:Any]] = d["weeks"] as? [[String:Any]]
                                {
                                    dict1["data"] = arr
                                }
                                self.tblArray[0] = dict1
                                
                                let dict2:[String:Any] = ["section":"Filtrar por Región", "data":arr]
                                self.tblArray[1] = dict2
                                
                                if let arr1:[[String:Any]] = dicy["channels"] as? [[String:Any]]
                                {
                                    let dict3:[String:Any] = ["section":"Filtrar por Canal", "data":arr1]
                                    self.tblArray[2] = dict3
                                }
                            }
                        }
                        
                        k_helper.defaultArray_Filter = self.tblArray
                        
                        //  print(self.tblArray)
                        self.tblView.delegate = self
                        self.tblView.dataSource = self
                        self.tblView.reloadData()
                        
                        if k_helper.firstTimeOnly_CallFilterClickProgramatically == true
                        {
                            k_helper.firstTimeOnly_CallFilterClickProgramatically = false
                            self.btnFilterClick(btn: UIButton())
                        }
                    }
                }
            }
        }
    }
    
    func setupPicker()
    {
        self.arrPicker = []
        for d in self.arrAllPickers
        {
            if let str:String = d["name"] as? String
            {
                self.arrPicker.append(str)
            }
        }
        
        if self.arrPicker.count>0
        {
            lblMonth.text = self.arrPicker.first!
        }
    }
}
