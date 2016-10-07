//
//  EventApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class EventApi {
    
    class func ADD(calendarId:String,eventId:String){
        
        let urlString = "\(Constants.urlServerUpdateEvent)\(eventId)&\(calendarId)"
     
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

    
}
