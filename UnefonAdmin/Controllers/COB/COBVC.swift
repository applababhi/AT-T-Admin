//
//  COBVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 9/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class COBVC: UIViewController {

    @IBOutlet weak var lblNoResult:UILabel!
    @IBOutlet weak var txtFld:UITextField!
    @IBOutlet weak var btnBuscar:UIButton!
    @IBOutlet weak var vContainer1:UIView!
    @IBOutlet weak var vContainer2:UIView!
    @IBOutlet weak var vContainer3:UIView!
    @IBOutlet weak var c_tfV_wd:NSLayoutConstraint!
    @IBOutlet weak var c_btn_wd:NSLayoutConstraint!
    @IBOutlet weak var c_v1_Ht:NSLayoutConstraint!
    
    @IBOutlet weak var c_lNoRes_Tp:NSLayoutConstraint!
    @IBOutlet weak var c_v1_Tp:NSLayoutConstraint!
    @IBOutlet weak var c_v2_Tp:NSLayoutConstraint!
    @IBOutlet weak var c_v3_Tp:NSLayoutConstraint!
    
    var arrData1:[[String:Any]] = []
    var arrData2:[[String:Any]] = []
    var arrData3:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  txtFld.text = "04200"
        
        btnBuscar.layer.cornerRadius = 7.0
        self.txtFld.delegate = self
        txtFld.layer.cornerRadius = 5.0
        txtFld.layer.borderColor = UIColor.lightGray.cgColor
        txtFld.layer.borderWidth = 1.0
        txtFld.layer.masksToBounds = true
                                
        addLeftPaddingToWith(TextField: txtFld)
        txtFld.setPlaceHolderColorWith(strPH: "")
        
        if isPad
        {
            c_tfV_wd.constant = 250
            c_v1_Ht.constant = 205
        }
        else
        {
            // phone
            c_tfV_wd.constant = 140
            c_btn_wd.constant = 110
            c_v1_Ht.constant = 170
            c_lNoRes_Tp.constant = 2
            c_v1_Tp.constant = 5
            c_v2_Tp.constant = 5
            c_v3_Tp.constant = 5
        }
    }
    
    @IBAction func btnBuscarClick(btn:UIButton)
    {
        self.view.endEditing(true)
        if self.txtFld.text!.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            // call Api
            callGetCobZipcodeData()
        }
    }
    
    func addLeftPaddingToWith(TextField:UITextField)
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
}

extension COBVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension COBVC
{
    func callGetCobZipcodeData()
    {
        deleteViews()
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["zip_code":txtFld.text!]
        WebService.requestService(url: ServiceName.GET_COBZipcodeData.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let str:String = di["zip_code"] as? String
                            {
                                self.arrData1.append(["title":"Código Postal", "subTitle":str])
                            }
                            
                            if let str:String = di["state"] as? String
                            {
                                self.arrData1.append(["title":"Entidad", "subTitle":str])
                            }
                            
                            if let str:String = di["municipality"] as? String
                            {
                                self.arrData1.append(["title":"Municipio", "subTitle":str])
                            }
                            
                            if let str:String = di["place"] as? String
                            {
                                self.arrData1.append(["title":"Colonia", "subTitle":str])
                            }
                            
                            /////////////////
                            
                            if let check:Int = di["own_4g_guaranteed"] as? Int
                            {
                                self.arrData2.append(["title":"AT&T 4G LTE", "subTitle":"Garantizada", "check":check])
                            }
                            if let check:Int = di["own_4g_outdoor"] as? Int
                            {
                                self.arrData2.append(["title":"AT&T 4G LTE", "subTitle":"Outdoor", "check":check])
                            }
                            if let check:Int = di["own_3g_guaranteed"] as? Int
                            {
                                self.arrData2.append(["title":"AT&T 3G", "subTitle":"Garantizada", "check":check])
                            }
                            if let check:Int = di["own_3g_outdoor"] as? Int
                            {
                                self.arrData2.append(["title":"AT&T 3G", "subTitle":"Outdoor", "check":check])
                            }
                            
                            /////////////////////
                            
                            if let check:Int = di["ext_4g_telcel"] as? Int
                            {
                                self.arrData3.append(["title":"4G LTE", "subTitle":"Telcel", "check":check])
                            }
                            if let check:Int = di["ext_3g_telcel"] as? Int
                            {
                                self.arrData3.append(["title":"3G", "subTitle":"Telcel", "check":check])
                            }
                            if let check:Int = di["ext_2g_telcel"] as? Int
                            {
                                self.arrData3.append(["title":"2G GSM", "subTitle":"Telcel", "check":check])
                            }
                            if let check:Int = di["ext_3g_movistar"] as? Int
                            {
                                self.arrData3.append(["title":"3G", "subTitle":"Movistar", "check":check])
                            }
                            if let check:Int = di["ext_2g_movistar"] as? Int
                            {
                                self.arrData3.append(["title":"2G GSM", "subTitle":"Movistar", "check":check])
                            }
                            
                            DispatchQueue.main.async {
                                self.setUpViews()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteViews()
    {
        lblNoResult.isHidden = false
        for v in vContainer1.subviews
        {
            v.removeFromSuperview()
        }
        for v in vContainer2.subviews
        {
            v.removeFromSuperview()
        }
        for v in vContainer3.subviews
        {
            v.removeFromSuperview()
        }
        arrData1.removeAll()
        arrData2.removeAll()
        arrData3.removeAll()
    }
    
    func setUpViews()
    {
        lblNoResult.isHidden = true
        vContainer1.layer.cornerRadius = 6.0
        vContainer1.layer.borderColor = UIColor.lightGray.cgColor
        vContainer1.layer.borderWidth = 1.0
        vContainer1.layer.masksToBounds = true
        
        vContainer2.layer.cornerRadius = 6.0
        vContainer2.layer.borderColor = UIColor.lightGray.cgColor
        vContainer2.layer.borderWidth = 1.0
        vContainer2.layer.masksToBounds = true

        vContainer3.layer.cornerRadius = 6.0
        vContainer3.layer.borderColor = UIColor.lightGray.cgColor
        vContainer3.layer.borderWidth = 1.0
        vContainer3.layer.masksToBounds = true

        let controller: CobCollV1VC = AppStoryBoards.COB.instance.instantiateViewController(withIdentifier: "CobCollV1VC_ID") as! CobCollV1VC
        controller.arrData = arrData1
        controller.view.frame = vContainer1.bounds;
        controller.willMove(toParent: self)
        vContainer1.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
        
        let controller2: CobCollV2VC = AppStoryBoards.COB.instance.instantiateViewController(withIdentifier: "CobCollV2VC_ID") as! CobCollV2VC
        controller2.arrData = arrData2
        controller2.view.frame = vContainer2.bounds;
        controller2.willMove(toParent: self)
        vContainer2.addSubview(controller2.view)
        self.addChild(controller2)
        controller2.didMove(toParent: self)

        let controller3: CobCollV3VC = AppStoryBoards.COB.instance.instantiateViewController(withIdentifier: "CobCollV3VC_ID") as! CobCollV3VC
        controller3.arrData = arrData3
        controller3.view.frame = vContainer3.bounds;
        controller3.willMove(toParent: self)
        vContainer3.addSubview(controller3.view)
        self.addChild(controller3)
        controller3.didMove(toParent: self)
    }
}
