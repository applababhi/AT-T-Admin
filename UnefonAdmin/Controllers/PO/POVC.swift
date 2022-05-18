//
//  POVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 28/1/20.
//  Copyright © 2020 Shalini Sharma. All rights reserved.
//

import UIKit

class POVC: UIViewController {

    @IBOutlet weak var txtFldRegion:UITextField!
    @IBOutlet weak var txtFldChannel:UITextField!
    @IBOutlet weak var txtFldPeriod:UITextField!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var vContainer:UIView!
    @IBOutlet weak var c_tfReg_Wd:NSLayoutConstraint!
    
    @IBOutlet weak var c_vTFs_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_3TF_Tp:NSLayoutConstraint!
    @IBOutlet weak var c_1TF_Tp:NSLayoutConstraint!
    @IBOutlet weak var c_3TF_Ld:NSLayoutConstraint!
    
    var dictMain:[String:Any] = [:]
    var arrRegion:[[String:Any]] = []
    var arrChannel:[[String:Any]] = []
    var arrPeriod:[[String:Any]] = []
    
    var reffTapTF:UITextField!
    var picker : UIPickerView!
    
    var month_id = ""
    var region_id = ""
    var channel_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupTF()
//        callGetRegions()
        callUpdateRedLabel()
    }
    
    func setupTF()
    {
        if isPad
        {
            c_tfReg_Wd.constant = 160
        }
        else
        {
            c_tfReg_Wd.constant = 120
            c_vTFs_Ht.constant = 130
            c_1TF_Tp.constant = -35
            c_3TF_Tp.constant = 66
            c_3TF_Ld.constant = -250
        }
        
        btnNext.layer.cornerRadius = 5.0
        btnNext.layer.masksToBounds = true
        
        txtFldRegion.text = ""
        txtFldChannel.text = ""
        txtFldPeriod.text = ""
        
        txtFldRegion.layer.cornerRadius = 5.0
        txtFldRegion.layer.borderColor = UIColor.lightGray.cgColor
        txtFldRegion.layer.borderWidth = 1.0
        txtFldRegion.layer.masksToBounds = true
        
        txtFldChannel.layer.cornerRadius = 5.0
        txtFldChannel.layer.borderColor = UIColor.lightGray.cgColor
        txtFldChannel.layer.borderWidth = 1.0
        txtFldChannel.layer.masksToBounds = true
        
        txtFldPeriod.layer.cornerRadius = 5.0
        txtFldPeriod.layer.borderColor = UIColor.lightGray.cgColor
        txtFldPeriod.layer.borderWidth = 1.0
        txtFldPeriod.layer.masksToBounds = true
        
        addLeftPadding(TextField: txtFldRegion)
        addLeftPadding(TextField: txtFldChannel)
        addLeftPadding(TextField: txtFldPeriod)
        
        addRightPadding(TextField: txtFldRegion, imageName: "down")
        addRightPadding(TextField: txtFldChannel, imageName: "down")
        addRightPadding(TextField: txtFldPeriod, imageName: "down")
        
        self.txtFldRegion.tag = 101
        self.txtFldChannel.tag = 102
        self.txtFldPeriod.tag = 103
        
        self.txtFldRegion.delegate = self
        self.txtFldChannel.delegate = self
        self.txtFldPeriod.delegate = self

    }
    
    @IBAction func buscarClicked(btn:UIButton)
    {
        if month_id == "" || region_id == "" || channel_id == ""
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            // call Buscar Api
            callAPIforBuscar()
        }
    }
    
    func addLeftPadding(TextField:UITextField)
        {
            let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
            viewT.backgroundColor = .clear
            
            TextField.leftViewMode = UITextField.ViewMode.always
            TextField.leftView = viewT
        }
  
    func addRightPadding(TextField:UITextField, imageName:String)
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

extension POVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 101
        {
            // Region
            reffTapTF = textField
            showPickerView()
        }
        else if textField.tag == 102
        {
            // Channel
            reffTapTF = textField
            showPickerView()
        }
        else
        {
            // Period 103
            reffTapTF = textField
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 101
        {
            // Region
           // textField.text!
           // arrRegion
            
            // region_id
        }
        else if textField.tag == 102
        {
            // Channel
            
        }
        else
        {
            // Period
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension POVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
    }
    
    override func viewWillLayoutSubviews() {
        
        if isPad
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
            {
                c_tfReg_Wd.constant = 210
            }
            else
            {
                c_tfReg_Wd.constant = 160
            }
        }
    }
}

extension POVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        if reffTapTF.tag == 101
        {
            // region
         //   print(arrLevel_Picker)
            return arrRegion.count
        }
        else if reffTapTF.tag == 102
        {
            // channel
            return arrChannel.count
        }
        else
        {
            // period
            return arrPeriod.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strT:String = ""
        
        if reffTapTF.tag == 101
        {
            // Region
            let dict:[String:Any] = arrRegion[row]
            var strTitle = ""
            if let st:String = dict["region_name"] as? String
            {
                strTitle = st
            }
            return strTitle
        }
        else if reffTapTF.tag == 102
        {
            // Channel
            let dict:[String:Any] = arrChannel[row]
            var strTitle = ""
            if let strW:String = dict["channel_name"] as? String
            {
                strTitle = strW
            }
            
            return strTitle
        }
        else
        {
          // Period
            let dict:[String:Any] = arrPeriod[row]
            var strTitle = ""
            
            if let str:String = dict["name"] as? String
            {
                strTitle = str
            }
            return strTitle
        }

        return strT
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if reffTapTF.tag == 101
        {
            // Region
            let dict:[String:Any] = arrRegion[row]
            
            if let str:String = dict["region_name"] as? String
            {
                reffTapTF.text = str
                
                if let strID:Int = dict["region_id"] as? Int
                {
                    self.region_id = "\(strID)"
                }
            }
        }
        else if reffTapTF.tag == 102
        {
            // Channel
            let dict:[String:Any] = arrChannel[row]
            if let strW:String = dict["channel_name"] as? String
            {
                reffTapTF.text = strW
            }
            
            if let strID:String = dict["channel_id"] as? String
            {
                self.channel_id = "\(strID)"
            }
        }
        else
        {
            // Period
            let dict:[String:Any] = arrPeriod[row]
            
            if let str:String = dict["name"] as? String
            {
                reffTapTF.text = str
                
                if let strID:String = dict["id"] as? String
                {
                    self.month_id = "\(strID)"
                }
            }
        }
    }
}
