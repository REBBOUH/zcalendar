//
//  UserApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class UserApi {
    
    
    class func GETALL(begin:()->(),success:@escaping ( _ userInfo:[String:Any])->()){
        
        let urlString = "\(Constants.urlServerchecklist)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        request.addValue(DataManager.getToken(), forHTTPHeaderField: "x-custom-token")
        
        begin()
        
        let task =   session.dataTask(with: request as URLRequest, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: .notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as?  [String:AnyObject]) {
                            
                            success(jsonResult)
                            
                            
                            NotificationCenter.default.post(name: .notificationusergetok, object: nil, userInfo: ["data":jsonResult])
                            
                        }
                        
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NotificationCenter.default.post(name: .notificationconxerror, object: nil)
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    
    class func ADD(userInfo:[String:AnyObject],begin:()->(),success:()->()){
        
        let urlString = "\(Constants.urlServerAuthenticate)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = NSMutableURLRequest(url:url as URL)
        
        request.httpMethod = "POST"
        
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: userInfo, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        begin()
        
        let task =   session.dataTask(with: request as URLRequest, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: .notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(with: data!, options:.mutableContainers)) as?  [String: AnyObject]) {
                            
                            if let token = jsonResult["token"] as? String {
                                
                                DataManager.initToken(token)
                                
                            }
                        }
                        
                        NotificationCenter.default.post(name: .notificationuseraddok, object: nil)
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NotificationCenter.default.post(name: .notificationuseradderror, object: nil)
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    class func CONNECT(value:NSString,begin:()->(),success:()->()){
        
        let urlString = "\(Constants.urlServerConnect)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        let userPasswordData = value.data(using: String.Encoding.utf8.rawValue)
        
        let base64EncodedCredential = userPasswordData!.base64EncodedString()
        
        let authString = "Basic \(base64EncodedCredential)"
        
               request.httpMethod = "GET"
        
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        
        begin()
        
        print(request.description)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: .notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                    //print(responseServer.description)
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(with: data!, options:.mutableContainers)) as?  [String: AnyObject]) {
                            
                            if let token = jsonResult["token"] as? String , let userInfo = jsonResult["user"] as? [String:AnyObject] {
                                
                                DataManager.initToken(token)
                                DataManager.initUserInfo(userInfo)
                                
                            }
                        }
                        
                        NotificationCenter.default.post(name: .notificationusergetok, object: nil)
                        
                    }else{
                        if responseServer.statusCode == 403 {
                            
                            NotificationCenter.default.post(name: .notificationusergeterror, object: nil)
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    
    
    
}
