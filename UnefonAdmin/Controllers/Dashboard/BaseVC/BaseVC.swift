//
//  BaseVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 7/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    @IBOutlet weak var tblViewMenu:UITableView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var lblLastUpdate:UILabel!
    @IBOutlet weak var btnFilter:UIButton!
    @IBOutlet weak var imgVLogo:UIImageView!
    
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var viewFilter:UIView!
    @IBOutlet weak var viewFilterInner:UIView!
    
    @IBOutlet weak var c_lblHead_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_vHeader_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_vMenu_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_lblHead_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_vFilter_Tr:NSLayoutConstraint!
    @IBOutlet weak var c_vFilter_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_imgLogo_Wd:NSLayoutConstraint!
    //   @IBOutlet weak var c_bLogout_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_lHead_Bt:NSLayoutConstraint!
    @IBOutlet weak var c_bFilter_Wd:NSLayoutConstraint!
    @IBOutlet weak var c_bFilter_Ht:NSLayoutConstraint!
    
    var check_FilterOpen = false
    var selectedDashboardName = "VS"    
    
    var arrMenu:[[String:Any]] = [["title":"VS", "selected":true], ["title":"ACT", "selected":false], ["title":"DIS", "selected":false], ["title":"PO", "selected":false], ["title":"INS", "selected":false], ["title":"COB", "selected":false], ["title":"Logout", "selected":false]]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblLastUpdate.text = "NA"
        
        tblViewMenu.delegate = self
        tblViewMenu.dataSource = self
        
        lblHeader.text = "Activaciones INAR vs CIS"
        //viewContainer.backgroundColor = UIColor.red
        viewFilterInner.backgroundColor = .black // UIColor(named: "Purple")
        btnFilter.layer.cornerRadius = 5.0
        
        if isPad == false
        {
            c_bFilter_Wd.constant = 30
            c_bFilter_Ht.constant = 30
            //           c_bFilterVFilter_Horz.constant = -5
            btnFilter.setImage(UIImage(named: "filterPhn"), for: .normal)
        }
        
        viewFilter.alpha = 0
        self.perform(#selector(self.showFilterButton), with: nil, afterDelay: 0.1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushTokenToServer(_:)), name: Notification.Name("pushTokenToServer"), object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(self.filterValuesModified(_:)), name: NSNotification.Name(rawValue: "filterModified"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLastDateLabel), name: Notification.Name("lastUpdateLabel"), object: nil)

        if k_helper.checkCallPushTokenApi == true
        {
            callApiPushToken()
        }
        
        setBaseViewContainer(str: selectedDashboardName, resetFilter: true, callNotificationToGetSameFilterDict: false, dict2Pas: [:])
    }
    
    @objc func updateLastDateLabel(){
        
        lblLastUpdate.font = UIFont(name: CustomFont.regular, size: 11.0)
        if isPad{
            lblLastUpdate.font = UIFont(name: CustomFont.light, size: 14.0)
        }
        
        self.lblLastUpdate.text = k_helper.lastUpdateLabel
    }
    
    @objc func showFilterButton()
    {
        if isPad
        {
            lblHeader.font = UIFont(name: CustomFont.semiBold, size: 19.0)
            c_vHeader_Ht.constant = 80
            c_lblHead_Wd.constant = 300
            c_vMenu_Wd.constant = 90
            c_imgLogo_Wd.constant = 90
            let widthContainer_iPad = UIScreen.main.bounds.width - 90 // 90 is Menu table View
            
            var widthFilter_iPad:CGFloat = 0.0
            
            if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
            {
                widthFilter_iPad = widthContainer_iPad/2.5
            }
            else
            {
                widthFilter_iPad = widthContainer_iPad/3.7
            }
            
            c_vFilter_Wd.constant = widthFilter_iPad + 10 // 10, because it ll increase inner black area of filter view
            c_vFilter_Tr.constant =  0 - (widthFilter_iPad + 10) // -(widthFilter_iPad + 10) will basically just show Filter button hanging out in right
        }
        else
        {
            // PHONE
            c_vHeader_Ht.constant = 80
            c_imgLogo_Wd.constant = 42
            imgVLogo.contentMode = .scaleAspectFit
            imgVLogo.clipsToBounds = true
            //          c_bLogout_Ht.constant = 50
            c_lblHead_Wd.constant = 300
            c_lHead_Bt.constant = 0
            c_lblHead_Ht.constant = 14
            
            lblHeader.font = UIFont(name: CustomFont.semiBold, size: 13.0)
            let widthContainer_iPhone = UIScreen.main.bounds.width - 70 // 70 is Menu table View
            let widthFilter_iPhone = widthContainer_iPhone/1.2
            c_vFilter_Wd.constant = widthFilter_iPhone
            c_vFilter_Tr.constant = 0 - (widthFilter_iPhone) 
        }
        
        UIView.animate(withDuration: 1.0) {
            self.viewFilter.alpha = 1.0
        }
    }
    
    // handle notification
    @objc func filterValuesModified(_ notification: NSNotification)
    {
        // print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary?
        {
            check_FilterOpen = true
            btnShowFilterClick(btn: UIButton())
            
            print("- Call Api to load dashboard - ", selectedDashboardName)
            // Call API to Show Dashboard, ViewContainer
            callAPIToLoadDashBoardFor(strDashboardName: selectedDashboardName, payload:dict as! [String : Any])
        }
    }
    
    @objc func pushTokenToServer(_ notification: NSNotification)
    {
        print("- Call Api to upload push token - ", deviceToken_FCM)
        callApiPushToken()
    }
    
    @IBAction func btnShowFilterClick(btn:UIButton)
    {
        check_FilterOpen = !check_FilterOpen
        
        if isPad
        {
            if self.check_FilterOpen == true
            {
                // show view
                self.c_vFilter_Tr.constant = 0
            }
            else
            {
                // hide view
                //                if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
                //                {
                //                    let widthContainer_iPad = UIScreen.main.bounds.height - 90 // 90 is Menu table View
                //                    let widthFilter_iPad = widthContainer_iPad/3.7
                //                    c_vFilter_Wd.constant = widthFilter_iPad
                //                    self.c_vFilter_Tr.constant = 50 - widthFilter_iPad
                //                }
                //                else
                //                {
                //                    // portrait
                //                    let widthContainer_iPad = UIScreen.main.bounds.width - 90 // 90 is Menu table View
                //                    let widthFilter_iPad = widthContainer_iPad/2.5
                //                    c_vFilter_Wd.constant = widthFilter_iPad
                //                    self.c_vFilter_Tr.constant = 50 - widthFilter_iPad
                //                }
                showFilterButton()
            }
        }
        else
        {
            if self.check_FilterOpen == true
            {
                // show view
                self.c_vFilter_Tr.constant = 0
            }
            else
            {
                // hide view
                //                let widthContainer_iPhone = UIScreen.main.bounds.width - 70 // 90 is Menu table View
                //                let widthFilter_iPhone = widthContainer_iPhone/1.1
                //                c_vFilter_Tr.constant = 50 - widthFilter_iPhone // 50 because of button, we show more over container
                showFilterButton()
            }
        }
    }
    
}

extension BaseVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        check_FilterOpen = false
        //        if UIDevice.current.orientation.isLandscape
        //        {
        //            print("landscape, Hide Filter View")
        //            let widthContainer_iPad = UIScreen.main.bounds.height - 90 // 90 is Menu table View
        //            let widthFilter_iPad = widthContainer_iPad/2.5
        //            c_vFilter_Tr.constant = 50 - widthFilter_iPad
        //        }
        //        else
        //        {
        //            print("portrait, Hide Filter View")
        //            let widthContainer_iPad = UIScreen.main.bounds.width - 90 // 90 is Menu table View
        //            let widthFilter_iPad = widthContainer_iPad/2.5
        //            c_vFilter_Tr.constant = 50 - widthFilter_iPad
        //        }
        
        // hide opened filter view on Rotation
        showFilterButton()
    }
}

extension BaseVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // on basis of viewMenu Width
        return (isPad == true) ? 90 : 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // MENU
        let cell:CellMenu_Rows = tblViewMenu.dequeueReusableCell(withIdentifier: "CellMenu_Rows", for: indexPath) as! CellMenu_Rows
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblTitle.textColor = UIColor.white
        
        cell.imagView.isHidden = true
        cell.imagView.contentMode = .center
        
        if isPad
        {
            cell.c_lbl_Wd.constant = 64
            cell.c_lbl_Ht.constant = 64
            
            cell.lblTitle.layer.cornerRadius = 32.0
            cell.lblTitle.font = UIFont(name: CustomFont.semiBold, size: 22.0)
        }
        else
        {
            cell.c_lbl_Wd.constant = 44
            cell.c_lbl_Ht.constant = 44
            
            cell.imagView.contentMode = .scaleAspectFit   // LOGOUT Image
            cell.c_img_Ht.constant = 23
            
            cell.lblTitle.layer.cornerRadius = 22.0
            cell.lblTitle.font = UIFont(name: CustomFont.semiBold, size: 16.0)
        }
        
        cell.lblTitle.layer.borderColor = UIColor.white.cgColor
        cell.lblTitle.layer.borderWidth = 3.0
        cell.lblTitle.layer.masksToBounds = true
        
        let di:[String:Any] = arrMenu[indexPath.row]
        
        if let strMenu:String = di["title"] as? String
        {
            cell.lblTitle.text = strMenu
            
            if strMenu == "Logout"
            {
                cell.lblTitle.text = ""
                cell.imagView.isHidden = false
                cell.imagView.image = UIImage(named: "logout")
            }
            
        }
        
        if let sel:Bool = di["selected"] as? Bool
        {
            if sel == true
            {
                cell.lblTitle.layer.borderColor = UIColor(named: "customBlue")?.cgColor
                cell.lblTitle.textColor = UIColor(named: "customBlue")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let di:[String:Any] = arrMenu[indexPath.row]
        if let strMenu:String = di["title"] as? String
        {
            // Logout Case
            if strMenu == "Logout"
            {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Cerrar sesión", message: "Estás seguro de que quieres desconectarte?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("Yes Logout Pressed")
                        
                        self.callApiDeletePushToken()
                    }
                    let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Logout Pressed")
                    }
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                return
            }
            
            selectedDashboardName = strMenu
            k_helper.firstTimeOnly_CallFilterClickProgramatically = true
            setBaseViewContainer(str: strMenu, resetFilter: false, callNotificationToGetSameFilterDict: true, dict2Pas: [:]) // change resetFilter to FALSE, 10Feb, to pass already selected same filter to all VC selected
        }
        
        for index in 0..<arrMenu.count
        {
            var dict:[String:Any] = arrMenu[index]
            dict["selected"] = false
            
            if indexPath.row == index
            {
                dict["selected"] = true
            }
            
            arrMenu[index] = dict
        }
        
        tableView.reloadData()
    }
    
    func setBaseViewContainer(str:String, resetFilter:Bool, callNotificationToGetSameFilterDict:Bool, dict2Pas:[String:Any])
    {
        print("you Tapped on - ", str)
        
        viewFilter.isHidden = false
        btnFilter.isHidden = false
        
        if resetFilter == true
        {
            for views in viewFilterInner.subviews
            {
                views.removeFromSuperview()
            }
            
            let controller: FilterVC = AppStoryBoards.Customs.instance.instantiateViewController(withIdentifier: "FilterVC_ID") as! FilterVC
            controller.view.frame = self.viewFilterInner.bounds;
            controller.willMove(toParent: self)
            self.viewFilterInner.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        
        if callNotificationToGetSameFilterDict == true
        {
            // post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeVCPassOlderFilterDictDirectly_NoReset"), object: nil, userInfo: nil)
        }
        
        for views in viewContainer.subviews
        {
            views.removeFromSuperview()
        }
        
        if str == "VS"
        {
            callGetFilter_JustForRedUpdateLabelChange()
            lblHeader.text = "Activaciones INAR vs Efectivas"
            
            let vc: VSVC = AppStoryBoards.VS.instance.instantiateViewController(withIdentifier: "VSVC_ID") as! VSVC
            vc.dictMain = dict2Pas
            vc.view.frame = self.viewContainer.bounds;
            vc.willMove(toParent: self)
            self.viewContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
        else if str == "ACT"
        {
            callGetFilter_JustForRedUpdateLabelChange()
            lblHeader.text = "Activaciones"
            
            let vc: ACTVC = AppStoryBoards.ACT.instance.instantiateViewController(withIdentifier: "ACTVC_ID") as! ACTVC
            vc.dictFull = dict2Pas
            vc.view.frame = self.viewContainer.bounds;
            vc.willMove(toParent: self)
            self.viewContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
        else if str == "DIS"
        {
            callGetFilter_JustForRedUpdateLabelChange()
            lblHeader.text = "Activaciones Por Distribuidor"
            
            let vc: DISVC = AppStoryBoards.DIS.instance.instantiateViewController(withIdentifier: "DISVC_ID") as! DISVC
            vc.dictMain = dict2Pas
            vc.view.frame = self.viewContainer.bounds;
            vc.willMove(toParent: self)
            self.viewContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
        else if str == "PO"
        {
            lblHeader.text = "Port Out"
            viewFilter.isHidden = true
            btnFilter.isHidden = true
            
            let vc: POVC = AppStoryBoards.PO.instance.instantiateViewController(withIdentifier: "POVC_ID") as! POVC
            vc.view.frame = self.viewContainer.bounds;
            vc.willMove(toParent: self)
            self.viewContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
        else if str == "INS"
        {
            callGetFilter_JustForRedUpdateLabelChange()
            
            viewFilter.isHidden = true
            btnFilter.isHidden = true
            lblHeader.text = "Plan de Incentivos"
            
            let vc: UINavigationController = AppStoryBoards.INS.instance.instantiateViewController(withIdentifier: "Nav_INS_ID") as! UINavigationController
            vc.view.frame = self.viewContainer.bounds;
            vc.willMove(toParent: self)
            self.viewContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
        else if str == "COB"
        {
            callGetFilter_JustForRedUpdateLabelChange()
            
            viewFilter.isHidden = true
            btnFilter.isHidden = true
            lblHeader.text = "Cobertura"
            
            let vc: COBVC = AppStoryBoards.COB.instance.instantiateViewController(withIdentifier: "COBVC_ID") as! COBVC
            vc.view.frame = self.viewContainer.bounds;
            vc.willMove(toParent: self)
            self.viewContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
    }
}
