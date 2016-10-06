//
//  ApiManager.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 21/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class ApiManager {
    
    
    class func UpdateCalendar(calendarId:String,eventId:String){
        let urlString = "\(Constants.urlServerUpdateEvent)\(eventId)&\(calendarId)"
        print(urlString)
        let url:NSURL = NSURL(string: "\(urlString)")!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.addValue(Constants.token, forHTTPHeaderField: "x-custom-token")
        
        let task =   session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationeventconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? NSHTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationeventupdateok, object: nil)
                        
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationeventupdateerror, object: nil)
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    
    
    
    class func checkValue(calendarId:String,begin:()->(),success:( userInfo:[[String:AnyObject]])->()){
        
        let urlString = "\(Constants.urlServercheck)\(calendarId)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.addValue(Constants.token, forHTTPHeaderField: "x-custom-token")
        
        begin()
        
        let task =   session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationconxerror, object: nil)
                
                return
            }else{
                
                if let responseServer = response as? NSHTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as?  [[String:AnyObject]]) {
                            
                            success(userInfo: jsonResult)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationmailpasswordok, object: nil, userInfo: ["data":jsonResult])
                            
                        }else{
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationmailpasswordok, object: nil)
                            
                        }
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationmailpassworderror, object: nil)
                            
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    class func checkValueUser(begin:()->(),success:( userInfo:[String:AnyObject])->()){
        
        let urlString = "\(Constants.urlServerchecklist)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.addValue(Constants.token, forHTTPHeaderField: "x-custom-token")
        
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
    class func authenticateUser(userInfo:[String:AnyObject],begin:()->(),success:( userInfo:[String:AnyObject])->()){
        
        let urlString = "\(Constants.urlServerchecklist)"
        
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
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationuseradderror, object: nil)
                
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
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }
    
    
}
