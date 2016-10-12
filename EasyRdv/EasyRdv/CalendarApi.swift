//
//  CalendarApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class CalendarApi {
    
    
    class func GET(calendarId:String,begin:()->(),success:(calendarDic:Calendar)->()){
        
        let urlString = "\(Constants.urlServercheck)\(calendarId)"
        
        let url:URL = URL(string: urlString)!
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request:URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue(DataManager.getToken(), forHTTPHeaderField: "x-custom-token")
        
        begin()
        
        
        
        let task = session.dataTask( with:request , completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
            
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationconxerror), object: nil)
                
                return
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as?  [[String:AnyObject]]) {
                            
                            let calendar:Calendar = Calendar(eventInfos: jsonResult)
                            
                            success(calendar)
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationcalendarok), object: nil, userInfo: ["data":jsonResult])
                            
                        }else{
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationcalendarok), object: nil)
                            
                        }
                        
                    }else{
                        if responseServer.statusCode == 401 {
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationcalendarerror), object: nil)
                            
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }

    
    
}
