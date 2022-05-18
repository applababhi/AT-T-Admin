//
//  LoginVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var focusManagerTF : FocusManager?
    @IBOutlet weak var tfUsername: UnderlineTextField!
    @IBOutlet weak var tfPassword: UnderlineTextField!
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var btnLogin:UIButton!
        
    @IBOutlet weak var c_vBk_Wd_iPad:NSLayoutConstraint!
    @IBOutlet weak var c_vBk_Ht_iPad:NSLayoutConstraint!
    @IBOutlet weak var c_vBottomPrivacy:NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let username:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            if username != ""
            {
                tfUsername.text = username
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTFFocus()
        setUpTopBar()
        
        btnLogin.layer.cornerRadius = 5.0
        
        if isPad == true
        {
            c_vBk_Wd_iPad.constant = 375.0
            c_vBk_Ht_iPad.constant = 667
        }
        else
        {
            c_vBk_Wd_iPad.constant = UIScreen.main.bounds.size.width
            c_vBk_Ht_iPad.constant = UIScreen.main.bounds.size.height
        }
        
      //  tfUsername.text = "ar34f"
        
     //   tfPassword.text = "cleverflow"
        
   //     tfUsername.text = "demo_kam"
   //     tfPassword.text = "259BHX"
    }
    
    private func setupTFFocus()
    {
        self.focusManagerTF = FocusManager()
        if let focusManager = self.focusManagerTF {
            focusManager.addItem(item: self.tfUsername)
            focusManager.addItem(item: self.tfPassword)
           // focusManager.focus(index: 0)
        }
        
        tfUsername.delegate = self
        tfPassword.delegate = self
        tfPassword.isSecureTextEntry = true
        tfUsername.setPlaceHolderColorWith(strPH: "Ej: er793r")
        tfPassword.setPlaceHolderColorWith(strPH: "Introducir la contraseña")
        hideKeyboardWhenTappedAround()
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
        }
        else if strModel == "iPhone Max"
        {
        }
        else if strModel == "iPhone 5"
        {
            c_vBottomPrivacy.constant = 30
        }
    }
    
    @IBAction func forgotClicked(btn:UIButton)
    {
        let vc: ForgotVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "ForgotVC_ID") as! ForgotVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func registerClicked(btn:UIButton)
    {

    }
    
    @IBAction func loginClicked(btn:UIButton)
    {
        if validateTF() == true
        {
            callLoginApi()
        }
    }
    
    @IBAction func privacyClicked(btn:UIButton)
    {
        if let url = URL(string: "https://www.unefon.com.mx/legales/aviso-de-privacidad.php") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func contactClicked(btn:UIButton)
    {
        
    }
}

extension LoginVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}

extension LoginVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            focusManagerTF!.focusTouch(item: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func validateTF() -> Bool
    {
        if tfUsername.text!.isEmpty == true || tfPassword.text!.isEmpty == true
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return false
        }
        else
        {
            return true
        }
    }

}

//MARK: API CALLS
extension LoginVC
{
    func callLoginApi()
    {
        var version:String = ""
        if appVersion != nil{
            version = appVersion!
        }
        
        self.showSpinnerWith(title: "Cargando...")
//        let param: [String:Any] = ["username":tfUsername.text!, "password": tfPassword.text!.md5Value, "ios_app_version": version, "android_app_version": "", "android_notification_token": "", "ios_notification_token": deviceToken_FCM]
        
        let param: [String:Any] = ["supervisor_id":tfUsername.text!, "password": tfPassword.text!.md5Value]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_Login.rawValue, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
     //         print(jsonString)
            if error != nil
            {
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
                        
                        if let dictResp:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            k_userDef.setValue(self.tfUsername.text!, forKey: userDefaultKeys.user_Loginid.rawValue)
                            
                            if let checkUpdate:Int = dictResp["require_software_update"] as? Int
                            {
                                if checkUpdate == 1
                                {
                                    // Show Alert to update
                                    self.showAlertWithTitle(title: "Alerta", message: "Hay una nueva versión de la app disponible.", okButton: "Instalar", cancelButton: "Ahora No", okSelectorName: #selector(self.takeToStore))
                                }
                            }
                        }
                        k_userDef.synchronize()
                        
                        DispatchQueue.main.async {
                            
                            self.tfUsername.text = ""
                            self.tfPassword.text = ""
                            
                            k_helper.checkCallPushTokenApi = true
                            
                            let vc: BaseVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "BaseVC_ID") as! BaseVC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @objc func takeToStore()
    {
        let urlStr = "itms-apps://itunes.apple.com/app/radio-fm/id1004413147?mt=12"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)

        
        // var appID: String = infoDictionary["CFBundleIdentifier"]
        // var url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)")
        // https://apps.apple.com/in/app/whatsapp-desktop/id1147396723?mt=12
        // Homechow : "itunes.apple.com/us/app/homechow/id1435002621?ls=1&mt=8"
    }
}
