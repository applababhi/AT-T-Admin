//
//  Network.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import Alamofire

struct WebService
{
    static func requestService(url: String, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, encoding:String, viewController: UIViewController,  completion: @escaping CompletionHandler)
    {
        var updatedHeader: HTTPHeaders = headers
        let authHederPart1 = "\(Int(timestamp))-"
        let authHederPart2 = "\(Int(timestamp))\(platformAccessToken)".md5Value

        updatedHeader["Authorization"] = authHederPart1+authHederPart2
       // updatedHeader["Content-Type"] = "application/json"
//        print(updatedHeader)
        
        let urlToPass:String = "\(baseURL)" + url
        
        var encode: ParameterEncoding!
        if encoding == "JSON"
        {
           encode = JSONEncoding.default
        }
        else if encoding == "QueryString"
        {
            encode = URLEncoding.queryString
        }
        else
        {
            encode = URLEncoding.default
        }
        
        AF.request(urlToPass, method: method, parameters: parameters, encoding: encode, headers: updatedHeader).responseJSON{ (response:DataResponse) in
            
            if response.data == nil
            {
               // completion([:], "", nil)
               // return
            }
            
            let dat:Data = response.data!
            let strRes:String = String(data: dat, encoding: .utf8)!
            // print(strRes)
            
            switch response.result
            {
            case .success(let value):
                if let json:[String:Any] = value as? [String:Any]
                {
                    // Actual Result
                    completion(json,strRes, nil)
                }
                else if let jsonArray:[[String:Any]] = value as? [[String:Any]]
                {
                    // print("JSON is ARRAY : \(jsonArray)")
                    completion(["createdArray": jsonArray], strRes, nil)
                }
                
                break
            case .failure(let err):
                print("- - Error Came for - -> \(url)")
                print("- - - -")
                print("Request failed with error ->   \(err.localizedDescription)")
                                
                completion([:], strRes, err)
                break
            }
        }
    }
    
    static func uploadImage(url: String, method: HTTPMethod, parameter: Parameters, header: HTTPHeaders, image: UIImage, viewController: UIViewController, completion: @escaping CompletionHandler)
    {
        var updatedHeader: HTTPHeaders = header
        let authHederPart1 = "\(Int(timestamp))-"
        let authHederPart2 = "\(Int(timestamp))\(platformAccessToken)".md5Value
        
        updatedHeader["Authorization"] = authHederPart1+authHederPart2
        // updatedHeader["Content-Type"] = "application/json"
        print(updatedHeader)
        let urlToPass:String = "\(baseURL)" + url

        let imageData = image.jpegData(compressionQuality: 0.50)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "ios_file.png", mimeType: "image/png")
            for (key, value) in parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: urlToPass, headers: updatedHeader)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON{ response in
            //   print(response)
             let dat:Data = response.data!
             let strRes:String = String(data: dat, encoding: .utf8)!
             
             //     print("JSON: \(strRes)")
             
             if let json:[String:Any] = response.value as? [String:Any]
             {
                // print("JSON - - - - ", json)
                 if let errorStr:String = json["error"] as? String
                 {
                     print("ERROR - Upload - - - ")
                     
                     print(errorStr)
                     completion([:], strRes, NSError(domain:"", code:500, userInfo:json))
                     return
                 }
                 
                 // Actual Result
                 completion(json, strRes, nil)
             }
             else if let jsonArray:[[String:Any]] = response.value as? [[String:Any]]
             {
                 // print("JSON is ARRAY : \(jsonArray)")
                 completion(["createdArray": jsonArray], strRes, nil)
             }
             
         }
    }
}
