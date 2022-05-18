//
//  INSVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 28/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class INSVC: UIViewController {

    @IBOutlet weak var collView:UICollectionView!
    
    var arrData:[[String:Any]] = []   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collView.delegate = self
        collView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.callGetAvailablePlans()
    }
}

extension INSVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCell_InsList = collView.dequeueReusableCell(withReuseIdentifier: "CollCell_InsList", for: indexPath) as! CollCell_InsList
       
        cell.imgView.image = nil
        
        if let imgStr:String = dict["plan_button_url"] as? String
        {
            cell.imgView.setImageUsingUrl(imgStr)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.item]
        if let plan:String = dict["plan_id"] as? String
        {
            let vc:INSPlanDetailBaseVC = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "INSPlanDetailBaseVC_ID") as! INSPlanDetailBaseVC
            vc.plan_id = plan
            k_helper.arrHeader_INSPlanDetail = [["title":"STATUS GENERAL", "selected":true], ["title":"USUARIOS", "selected":false], ["title":"REPORTES", "selected":false]]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func viewWillLayoutSubviews() {
        collView.reloadData() // this will reload the collV in each orientation then set size
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = self.collView.frame.size.width
        
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        {
            // Portrait
            
            if isPad == true
            {
                return CGSize(width: 350, height: 200)
            }
            else
            {
                return CGSize(width: 250, height: 140)
            }
            
        }
        else
        {
            // Landscape
            return CGSize(width: 350, height: 200)
        }
    }
}

extension INSVC
{
    func callGetAvailablePlans()
    {
        self.arrData.removeAll()
        self.collView.reloadData()
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        WebService.requestService(url: ServiceName.GET_GetINSplans.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrData = arr
                            DispatchQueue.main.async {
                                self.collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
