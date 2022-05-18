//
//  Cell_INSPlanDetail_Dropdown.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 29/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class Cell_INSPlanDetail_Dropdown: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtFldLevel:UITextField!
    @IBOutlet weak var txtFldMonth:UITextField!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var c_vLevel_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_Horz:NSLayoutConstraint!
    
    var arrLevel_Picker:[[String:Any]] = []
    var arrMonth_Picker:[[String:Any]] = []
    
    var closure_UpdateLevelStr: (String) -> () = {(str:String) in}
    var closure_UpdateMonthStr: (String) -> () = {(str:String) in}

    var reffTapTF:UITextField!
    var picker : UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDelegates()
    {
        self.txtFldLevel.tag = 101
        self.txtFldMonth.tag = 102
        
        self.txtFldLevel.delegate = self
        self.txtFldMonth.delegate = self
    }
    
    func addLeftPaddingTo(TextField:UITextField)
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

    func addRightPaddingTo(TextField:UITextField, imageName:String)
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

extension Cell_INSPlanDetail_Dropdown: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 101
        {
            // LEVEL
            reffTapTF = textField
            showPickerView()
        }
        else if textField.tag == 102
        {
            // MONTH
            reffTapTF = textField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 101
        {
            // LEVEL
            closure_UpdateLevelStr(textField.text!)
        }
        else if textField.tag == 102
        {
            // Month
            closure_UpdateMonthStr(textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension Cell_INSPlanDetail_Dropdown: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: 216))
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
        if reffTapTF.tag == 101
        {
            // LEVEL
         //   print(arrLevel_Picker)
            return arrLevel_Picker.count
        }
        else if reffTapTF.tag == 102
        {
            // Month
            return arrMonth_Picker.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strT:String = ""
        
        if reffTapTF.tag == 101
        {
            // Level
            let dict:[String:Any] = arrLevel_Picker[row]
            var strTitle = ""
            if let st:String = dict["level_name"] as? String
            {
                strTitle = st
            }
            
            return strTitle
        }
        else if reffTapTF.tag == 102
        {
            // Month
            let dict:[String:Any] = arrMonth_Picker[row]
            var strTitle = ""
            if let st:String = dict["month_name"] as? String
            {
                strTitle = st
            }
            
            return strTitle
        }

        return strT
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if reffTapTF.tag == 101
        {
            // Level
            let dict:[String:Any] = arrLevel_Picker[row]
            if let st:String = dict["level_name"] as? String
            {
                reffTapTF.text = st
            }
        }
        else if reffTapTF.tag == 102
        {
            // Month
            let dict:[String:Any] = arrMonth_Picker[row]
            if let st:String = dict["month_name"] as? String
            {
                reffTapTF.text = st
            }
        }
    }
}
