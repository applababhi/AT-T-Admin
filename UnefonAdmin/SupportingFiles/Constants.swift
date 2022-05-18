//
//  Constants.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import UIKit

// let baseURL:String = "https://inspirum-unefon-sales-monitor-development.azurewebsites.net/"   // DEV
// let baseURL:String = "https://inspirum-unefon.azurewebsites.net/"   // OLD  PROD
let baseURL:String = "https://inspirum-unefon-sales-monitor-development.azurewebsites.net/"   // PROD

let k_baseColor:UIColor = UIColor(named: "customBlue")!
let k_window:UIWindow = UIApplication.shared.delegate!.window! as! UIWindow
let k_appDel:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
let localTimeZoneName: String = TimeZone.current.localizedName(for: .generic, locale: .current) ?? ""
let k_helper:Helper = Helper.shared
let k_userDef = UserDefaults.standard
let timestamp = Date().timeIntervalSince1970
var deviceToken_FCM = ""
var deviceToken = ""
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
 let platformAccessToken = "16a4bd1a40d8c6342ad19172dd31eade" // Dev
// let platformAccessToken = "16a4bd1a40d8c6342ad19172dd31eade" // PROD
var isPad: Bool{
    return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false
}
typealias CompletionHandler = ([String:Any], String, Error?) -> ()

enum ServiceName:String
{
    case POST_Login = "supervisors/credentials/validate"
    case GET_ForgotPasswordCode = "supervisors/password/request_recurity_code"
    case PUT_UpdatePassword = "supervisors/password/update"
    case GET_GetFilter = "reports/filters/get_template"
    case POST_getVSreport = "reports/vs/get_data"
    case POST_getACTreport = "reports/act/get_data"
    case POST_getDISreport = "reports/dis/get_data"
    case GET_GetINSplans = "plans/get_available"
    case GET_GetINSplanDetail_Status = "plans/general_status/default"
    case GET_GetINSplanDetail_Dropdowns = "plans/general_status/parameters"
    case GET_GetINSdetailReportsPicker = "plans/reviews/list"
    case POST_GetINSUsuarioGridUUIDs = "plans/users/search"
    case GET_UUIDtapUsuario = "plans/users/get"
    case GET_LeaderboardGeneralStatus = "plans/general_status"
    case GET_INSDetail_CountDropdown = "plans/users/performance/monthly_results"
    case GET_INSDetail_SingleBar = "plans/users/performance/daily_performance"
    case GET_INSDetail_DoubleBar_Weekly = "plans/users/performance/weekly_performance"
    case GET_INSDetail_DoubleBar_Monthly = "plans/users/performance/monthly_performance"
    case PUT_updateDeviceToken = "supervisors/ios_notification_tokens/update"
    case PUT_deleteDeviceToken = "supervisors/ios_notification_tokens/release"
    case GET_COBZipcodeData = "coverage/zones/get"
    case GET_GetPORegions = "regions/get_all_full"
    case GET_GetPOChannels = "channels/groups/get"
    case GET_GetPOPeriod = "reports/filters/get_months"
    case GET_GetLastUpdate = "portouts/last_updated"
    case POST_getPOsearch = "reports/po/get_data"
}

enum userDefaultKeys :String
{
    case user_Loginid = "AdminUnefon_LoginId"
}

struct CustomFont
{
    static let regular = "OpenSans-Regular"
    static let semiBold = "OpenSans-SemiBold"
    static let bold = "OpenSans-Bold"
    static let light = "OpenSans-Light"
}

enum AppStoryBoards : String
{
    case Main, Dashboard, Customs, Charts, VS, ACT, DIS, INS, COB, PO
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
