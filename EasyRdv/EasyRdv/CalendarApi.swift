//
//  CalendarApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class CalendarApi {
    
    
    class func GET(calendarId:String,begin:()->(),success:( calendarDic:Calendar)->()){
        
        let urlString = "\(Constants.urlServercheck)\(calendarId)"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        
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
                            
                            let calendar:Calendar = Calendar(eventInfos: jsonResult)
                            
                            success(calendarDic: calendar)
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationcalendarok, object: nil, userInfo: ["data":jsonResult])
                            
                        }else{
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationcalendarok, object: nil)
                            
                        }
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationcalendarerror, object: nil)
                            
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }

    
    
}
