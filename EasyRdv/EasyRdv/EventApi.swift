//
//  EventApi.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 07/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class EventApi {
    
    class func ADD(_ calendarId:String,eventId:String){
        
        let urlString = "\(Constants.urlServerUpdateEvent)\(eventId)&\(calendarId)"
     
        let url:URL = URL(string: "\(urlString)")!
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request:URLRequest = URLRequest(url: url)
        
        request.addValue(DataManager.getToken(), forHTTPHeaderField: "x-custom-token")
        
        let task =   session.dataTask(with: request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationeventconxerror), object: nil)
                
                return
                
            }else{
                
                if let responseServer = response as? HTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationeventupdateok), object: nil)
                        
                    }else{
                        
                        if responseServer.statusCode == 401 {
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notificationeventupdateerror), object: nil)
                        
                        }else{
                            
                        }
                    }
                }
            }
        })
        
        task.resume()
        
    }

    
}
