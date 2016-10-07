//
//  UserApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class UserApi {
    
    
    class func GETALL(begin:()->(),success:( userInfo:[String:AnyObject])->()){
        
        let urlString = "\(Constants.urlServerchecklist)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.addValue(DataManager.getToken(), forHTTPHeaderField: "x-custom-token")
        
        begin()
        
        let task =   session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? NSHTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as?  [String:AnyObject]) {
                            
                            success(userInfo: jsonResult)
                            
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationusergetok, object: nil, userInfo: ["data":jsonResult])
                            
                        }
                        
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationconxerror, object: nil)
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
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSMutableURLRequest(URL:url)
        
        request.HTTPMethod = "POST"
        
        
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(userInfo, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        begin()
        
        let task =   session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? NSHTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? NSJSONSerialization.JSONObjectWithData(data!, options:.MutableContainers)) as?  [String: AnyObject]) {
                                                        
                            if let token = jsonResult["token"] as? String {
                                
                                DataManager.initData(token)
                                
                            }
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationuseraddok, object: nil)
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationuseradderror, object: nil)
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
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        let userPasswordData = value.dataUsingEncoding(NSUTF8StringEncoding)
        
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let authString = "Basic \(base64EncodedCredential)"
        
        print("Basic \(base64EncodedCredential)")
        
        request.HTTPMethod = "GET"
        
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        
        begin()
        
        print(request.description)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? NSHTTPURLResponse {
                    //print(responseServer.description)
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? NSJSONSerialization.JSONObjectWithData(data!, options:.MutableContainers)) as?  [String: AnyObject]) {
                            
                            if let token = jsonResult["token"] as? String {

                                DataManager.initData(token)
                                
                            }
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationusergetok, object: nil)
                        
                    }else{
                        if responseServer.statusCode == 403 {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationusergeterror, object: nil)
                        
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }

    

    
}
