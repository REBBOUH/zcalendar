//
//  ApiManager.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 21/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

protocol parseCalendar {
    
    func createCalendar(jsonResult:[[String:AnyObject]])
    
}
class ApiManager {
 
    
    
    class func UpdateCalendar(eventId:String){
        let urlString = "\(Constants.urlServerLocalHost)/update/\(eventId)&\(CalendarSingleton.sharedInstance.event.end!.description.stringByReplacingOccurrencesOfString(" ", withString: ""))"
        
        let url:NSURL = NSURL(string: "\(urlString)")!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSURLRequest = NSMutableURLRequest(URL: url)
        
        let task =   session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
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
    
    
    class func checkValue(success:(userInfo:[[String:AnyObject]])->()){
        
        let urlString = "\(Constants.urlServerLocalHost)/check"
        
        let url:NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request:NSURLRequest = NSMutableURLRequest(URL: url)
        
        let task =   session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> () in
            
            if (error != nil) {
                
                print(error)
                
                return
            }else{
                
                if let responseServer = response as? NSHTTPURLResponse {
                    
                    if responseServer.statusCode == 200 {
                        
                        if  let jsonResult = ((try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as?  [[String:AnyObject]]) {
                       
                            success(userInfo: jsonResult)
                            
                         
                            NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationmailpasswordok, object: nil, userInfo: ["data":jsonResult])
                      
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
}
