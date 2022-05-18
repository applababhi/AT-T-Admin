//
//  CellINSPlanDetail_Usuarios3TF.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 2/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class CellINSPlanDetail_Usuarios3TF: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtFldNombre:UITextField!
    @IBOutlet weak var txtFldUUID:UITextField!
    @IBOutlet weak var txtFldNum:UITextField!
    @IBOutlet weak var c_vNum_Wd:NSLayoutConstraint!
    
    @IBOutlet weak var c_Horz1:NSLayoutConstraint!
    @IBOutlet weak var c_Horz2:NSLayoutConstraint!


    var closure_UpdateUUIDStr: (String) -> () = {(str:String) in}
    var closure_UpdateNombreStr: (String) -> () = {(str:String) in}
    var closure_UpdateNumStr: (String) -> () = {(str:String) in}

    
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
        self.txtFldUUID.tag = 101
        self.txtFldNombre.tag = 102
        self.txtFldNum.tag = 103

        
        self.txtFldUUID.delegate = self
        self.txtFldNombre.delegate = self
        self.txtFldNum.delegate = self
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
}

extension CellINSPlanDetail_Usuarios3TF: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 101
        {
            // UUID
            closure_UpdateUUIDStr(textField.text!)
        }
        else if textField.tag == 102
        {
            // Nombre
            closure_UpdateNombreStr(textField.text!)
        }
        else if textField.tag == 103
        {
            // Num
            closure_UpdateNumStr(textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
