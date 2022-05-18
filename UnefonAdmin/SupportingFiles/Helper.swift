//
//  Helper.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Helper: NSObject {

    static let shared = Helper()
    private override init() {}
    
    var defaultArray_Filter:[[String:Any]] = []
    var checkCallPushTokenApi = false
    var lastUpdateLabel:String = ""
    
    // 3 Different Reff holding CollV Dict for 3 types of Grid else, it scroll all together
    var reffAll_CollV_ForGrid_1:[UICollectionView] = []
    var reffAll_CollV_ForGrid_2:[UICollectionView] = []
    var reffAll_CollV_ForGrid_3:[UICollectionView] = []
    
    var firstTimeOnly_CallFilterClickProgramatically = true
    var arrHeader_INSPlanDetail:[[String:Any]] = []
}

