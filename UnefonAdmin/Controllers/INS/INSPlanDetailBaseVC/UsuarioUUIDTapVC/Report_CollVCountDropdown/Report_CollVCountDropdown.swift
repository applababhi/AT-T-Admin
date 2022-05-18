//
//  Report_CollVCountDropdown.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class Report_CollVCountDropdown: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var txtFld:UITextField!
    @IBOutlet weak var c_tf_Wd:NSLayoutConstraint!

    var arrData:[[String:Any]] = []
    
    var arr_Picker:[[String:Any]] = []
    var reffTapTF:UITextField!
    var picker : UIPickerView!
    
    var strPicker = ""
    var plan_id = ""
    var uuid = ""
    var closure_UpdateTable: ([[String:Any]], String) -> () = {(arr:[[String:Any]], str:String) in}

    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtFld.delegate = self
        txtFld.layer.cornerRadius = 5.0
        txtFld.layer.borderColor = UIColor.lightGray.cgColor
        txtFld.layer.borderWidth = 1.0
        txtFld.layer.masksToBounds = true
                                
        addLeftPaddingToNEW(TextField: txtFld)
        addRightPaddingToNEW(TextField: txtFld, imageName: "down")
        txtFld.setPlaceHolderColorWith(strPH: "Junio 2019")

        self.collView.delegate = self
        self.collView.dataSource = self
          
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collView?.setCollectionViewLayout(layout, animated: true)
        self.collView.reloadData()

        txtFld.text = strPicker

        if isPad == false
        {
            // iPHone
            c_tf_Wd.constant = 125
            lblTitle.font = UIFont(name: CustomFont.semiBold, size: 12)
            txtFld.font = UIFont(name: CustomFont.regular, size: 12)
        }

    }
    
    func addLeftPaddingToNEW(TextField:UITextField)
        {
            let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
            viewT.backgroundColor = .clear
            
            TextField.leftViewMode = UITextField.ViewMode.always
    //        let imageView = UIImageView(frame: CGRect(x: 3, y: 4, width: 20, height: 20))
    //        let image = UIImage(named: "search")
    //        imageView.image = image
    //        viewT.addSubview(imageView)
            TextField.leftView = viewT
        }

    func addRightPaddingToNEW(TextField:UITextField, imageName:String)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewT.backgroundColor = .clear
        
        TextField.rightViewMode = UITextField.ViewMode.always
        
        if imageName != ""
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .center
            let image = UIImage(named: imageName)
            imageView.image = image
            
            let templateImage = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.image = templateImage
            imageView.tintColor = UIColor.darkGray

            viewT.addSubview(imageView)
        }
        
        TextField.rightView = viewT
    }
}

extension Report_CollVCountDropdown: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        reffTapTF = textField
        showPickerView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        strPicker = textField.text!
        
        // call Api
        callGetValues()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension Report_CollVCountDropdown : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]

        let cell:Coll_INSPlanDetail_Counts = collectionView.dequeueReusableCell(withReuseIdentifier: "Coll_INSPlanDetail_Counts", for: indexPath) as! Coll_INSPlanDetail_Counts
        cell.lblTitle.text = ""
        cell.lblCount.text = ""
        cell.lblTitle.textColor = .lightGray
        cell.vBk.layer.cornerRadius = 6.0
        cell.vBk.layer.borderWidth = 1.0
        cell.vBk.layer.borderColor = UIColor.darkGray.cgColor
        cell.vBk.layer.masksToBounds = true
        
        if let str:String = dict["label"] as? String
        {
            cell.lblTitle.text = str
            
            if cell.lblTitle.text!.count > 14
            {
                cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 15)
            }
            
        }
        if let str:String = dict["title"] as? String
        {
            cell.lblCount.text = str
        }
        
        if indexPath.item == 0
        {
            cell.lblCount.textColor = UIColor.colorWithHexString("#36817A") // green
        }
        else if indexPath.item == 1
        {
            cell.lblCount.textColor = UIColor(named: "Pink")
        }
        else if indexPath.item == 2
        {
            cell.lblCount.textColor = k_baseColor
        }
        else
        {
            cell.lblCount.textColor = UIColor(named: "Purple")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {}
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isPad == true
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .faceDown
            {
                return CGSize(width: 235, height: 120)
            }
            else
            {
                return CGSize(width: 190, height: 120)
            }
        }
        // iPhone
        return CGSize(width: 190, height: 110)
    }
}

extension Report_CollVCountDropdown: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        reffTapTF.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        reffTapTF.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {

        picker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        reffTapTF.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
         return arr_Picker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dict:[String:Any] = arr_Picker[row]
        var strTitle = ""
        if let st:String = dict["month_name"] as? String
        {
            strTitle = st
        }
        
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let dict:[String:Any] = arr_Picker[row]
        if let st:String = dict["month_name"] as? String
        {
            reffTapTF.text = st
        }
    }
}

extension Report_CollVCountDropdown
{
    func callGetValues()
    {
        var monthID = ""
        
        for dic in arr_Picker
        {
            if let name:String = dic["month_name"] as? String
            {
                if name == strPicker
                {
                    if let stId:String = dic["month_id"] as? String
                    {
                        monthID = stId
                    }
                }
            }
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "uuid":uuid, "month_id":monthID]
        WebService.requestService(url: ServiceName.GET_INSDetail_CountDropdown.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        var arr_CollV:[[String:Any]] = []
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let str:String = di["sales_quantity_str"] as? String
                            {
                                arr_CollV.append(["title":str, "label":"Activaciones"])
                            }
                            if let str:String = di["kpi_quantity_str"] as? String
                            {
                                arr_CollV.append(["title":str, "label":"KPI"])
                            }
                            if let str:String = di["performance_str"] as? String
                            {
                                arr_CollV.append(["title":str, "label":"Logro"])
                            }
                            if let str:String = di["obtained_points_str"] as? String
                            {
                                arr_CollV.append(["title":str, "label":"Puntos Obtenidos"])
                            }
                        }
                        self.closure_UpdateTable(arr_CollV, self.strPicker)
                    }
                }
            }
        }
    }
}
