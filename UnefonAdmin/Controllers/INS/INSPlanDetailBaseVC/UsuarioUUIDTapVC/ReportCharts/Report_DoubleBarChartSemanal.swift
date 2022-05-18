//
//  Report_DoubleBarChartSemanal.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class Report_DoubleBarChartSemanal: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtFld:UITextField!
    
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var c_tf_Wd:NSLayoutConstraint!

    var arrData:[[String:Any]] = []
    var arr_Picker:[[String:Any]] = []
    var reffTapTF:UITextField!
    var picker : UIPickerView!
    var strPicker = ""
    var closure_UpdateTable: ([[String:Any]], String) -> () = {(arr:[[String:Any]], str:String) in}
    var plan_id = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTF()
        
        collView.delegate = self
        collView.dataSource = self
    }
    
    func setupTF()
    {
        self.txtFld.delegate = self
        txtFld.layer.cornerRadius = 5.0
        txtFld.layer.borderColor = UIColor.lightGray.cgColor
        txtFld.layer.borderWidth = 1.0
        txtFld.layer.masksToBounds = true
                                
        addLeftPaddingToNEW(TextField: txtFld)
        addRightPaddingToNEW(TextField: txtFld, imageName: "down")
        txtFld.setPlaceHolderColorWith(strPH: "Junio 2019")
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

extension Report_DoubleBarChartSemanal: UITextFieldDelegate
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

extension Report_DoubleBarChartSemanal: UIPickerViewDelegate, UIPickerViewDataSource
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

extension Report_DoubleBarChartSemanal : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_ReportMultipleBarChart = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_ReportMultipleBarChart", for: indexPath) as! CollCell_ReportMultipleBarChart
        
        cell.lblWeekName.text = ""
        cell.lblWeekRange.text = ""
        
        if let str:String = dict["week_name"] as? String
        {
            cell.lblWeekName.text = str
        }
        if let str:String = dict["week_id"] as? String
        {
            cell.lblWeekRange.text = str
        }
        
        if isPad == false
        {
            cell.lblWeekName.font = UIFont(name: CustomFont.regular, size: 10)
            cell.lblWeekRange.font = UIFont(name: CustomFont.regular, size: 7)
        }

        var di2Pas:[String:Any] = [:]
        if let bar:Int = dict["kpi_quantity"] as? Int
        {
            di2Pas["y1"] = bar
        }
        if let bar:Int = dict["sales_quantity"] as? Int
        {
            di2Pas["y2"] = bar
        }
        
        cell.setChart(dictEachCell: di2Pas)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
//    // To make Cells Display in Center
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        if isPad
//        {
//            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
//            {
//                let totalCellWidth = 120 * collectionView.numberOfItems(inSection: 0)
//                let totalSpacingWidth = 0
//
//                let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//                let rightInset = leftInset
//
//                print("- - - - -LANDScape Bar - - - - - - -")
//                return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//            }
//            else
//            {
//                let totalCellWidth = 120 * collectionView.numberOfItems(inSection: 0)
//                let totalSpacingWidth = 0
//
//                let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//                let rightInset = leftInset
//
//                print("- - - - - PORTRait Bar- - - - - - -")
//                return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//            }
//        }
//        else
//        {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//
//    }
//
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isPad
        {
            return CGSize(width: 120, height: 200)
        }
        else
        {
            return CGSize(width: 80, height: 200)
        }
    }
}

extension Report_DoubleBarChartSemanal
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
        WebService.requestService(url: ServiceName.GET_INSDetail_DoubleBar_Weekly.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        var arr_Double:[[String:Any]] = []
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let ar:[[String:Any]] = di["values"] as? [[String:Any]]
                            {
                                arr_Double = ar
                            }
                        }
                        self.closure_UpdateTable(arr_Double, self.strPicker)
                    }
                }
            }
        }
    }
}
