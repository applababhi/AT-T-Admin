
//
//  DISVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 19/9/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit

class DISVC: UIViewController {

    @IBOutlet weak var lblNoData:UILabel!
    @IBOutlet weak var viewGridContainer:UIView!
    
    var dictMain:[String:Any] = [:]
    var dictSelected:[String:Any] = [:]
    
    var arr_First_Week:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        k_helper.reffAll_CollV_ForGrid_1.removeAll()
        k_helper.reffAll_CollV_ForGrid_2.removeAll()
        k_helper.reffAll_CollV_ForGrid_3.removeAll()
        
        if dictMain.count == 0
        {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }
        
        setUpGrid()
    }
    
    func setUpGrid()
    {
        if let arAll:[[[String:Any]]] = dictMain["content"] as? [[[String:Any]]]
        {
            if arAll.count > 0
            {
                let a_FirstTemp:[[String:Any]] = arAll.first! // here i am just pretending and creating a sample first array to pass to Grid, to create aBlank Black Header, and second section ll be colorfull and ll be start from normal index zero to complete array count, not from 1 to count
                var a_First:[[String:Any]] = []
                
                if a_FirstTemp.count > 0
                {
                    let d:[String:Any] = a_FirstTemp.first!
                    
                    for _ in a_FirstTemp
                    {
                        var diT:[String:Any] = [:]
                        for key in d.keys
                        {
                            diT[key] = ""
                        }
                        a_First.append(diT)
                    }
                }
                
                var arRest:[[[String:Any]]] = []
                for index in 0..<arAll.count
                {
                    let aEach:[[String:Any]] = arAll[index]
                    arRest.append(aEach)
                }
                                
                let controller: GridVC = AppStoryBoards.Customs.instance.instantiateViewController(withIdentifier: "GridVC_ID") as! GridVC
                
                controller.arrFirstSection = a_First
                controller.arrMain = arRest
                
                controller.checkSpecialCase_DIS = true
                
                controller.isShowTopBlackHeaderTitlesInCenter = false
                controller.useValue_ForAllCollScrollsHorz = 1
                controller.view.frame = viewGridContainer.bounds;
                controller.willMove(toParent: self)
                viewGridContainer.addSubview(controller.view)
                self.addChild(controller)
                controller.didMove(toParent: self)
            }
        }
        
    }
}
