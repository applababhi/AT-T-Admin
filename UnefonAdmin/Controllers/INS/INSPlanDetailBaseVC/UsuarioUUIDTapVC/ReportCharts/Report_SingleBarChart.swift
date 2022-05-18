//
//  Report_SingleBarChart.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import Charts

class Report_SingleBarChart: UIViewController {

    @IBOutlet weak var viewBar:BarChartView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtFld:UITextField!
    
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
        
        var arrX:[String] = []
        var arrY:[Int] = []
        
        for di in arrData
        {
            if let strX:String = di["day_name"] as? String
            {
                arrX.append(strX)
            }
            if let bar:Int = di["sales_quantity"] as? Int
            {
                arrY.append(bar)
            }
        }
        
        setChart(dataPoints: arrX, values: arrY)
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
    
    func setChart(dataPoints: [String], values: [Int])
    {
        self.viewBar.drawBarShadowEnabled = false
        self.viewBar.drawValueAboveBarEnabled = true
        self.viewBar.chartDescription.enabled = false
        self.viewBar.legend.enabled = false
        
        let xAxis = viewBar.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.granularityEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = UIColor.black
        xAxis.wordWrapEnabled = true
        xAxis.labelFont = UIFont(name: CustomFont.regular, size: 14.0)!
        // below 2 lines will print xaxis string
        xAxis.setLabelCount(dataPoints.count, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)

        self.viewBar.leftAxis.drawLabelsEnabled = false
        self.viewBar.leftAxis.drawGridLinesEnabled = false
        self.viewBar.leftAxis.drawAxisLineEnabled = false
        
        self.viewBar.rightAxis.drawLabelsEnabled = false
        self.viewBar.rightAxis.drawGridLinesEnabled = false
        self.viewBar.rightAxis.drawAxisLineEnabled = false
        
        self.viewBar.animate(xAxisDuration: 1.3, yAxisDuration: 1.3)

        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = [UIColor(named: "customBlue")] as! [NSUIColor]
                
        let barChartData = BarChartData(dataSet: chartDataSet)
        barChartData.setValueFont(UIFont.systemFont(ofSize: 15.0))
        barChartData.barWidth = Double(0.7) // **default**: 0.85
        self.viewBar.data = barChartData

        viewBar.xAxis.drawGridLinesEnabled = false
        viewBar.rightAxis.enabled = false
        viewBar.data = barChartData
        
        // below lines of code, shrink the graph from left and right starting ending point
        let xAxisPadding = 0.45
        viewBar.xAxis.axisMinimum = -xAxisPadding
        viewBar.xAxis.axisMaximum = barChartData.xMax + xAxisPadding
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


extension Report_SingleBarChart: UITextFieldDelegate
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

extension Report_SingleBarChart: UIPickerViewDelegate, UIPickerViewDataSource
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

extension Report_SingleBarChart
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
        WebService.requestService(url: ServiceName.GET_INSDetail_SingleBar.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        var arr_Single:[[String:Any]] = []
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let ar:[[String:Any]] = di["values"] as? [[String:Any]]
                            {
                                arr_Single = ar
                            }
                        }
                        self.closure_UpdateTable(arr_Single, self.strPicker)
                    }
                }
            }
        }
    }
}
