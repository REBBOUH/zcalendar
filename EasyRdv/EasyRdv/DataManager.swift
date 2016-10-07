//
//  DataManager.swift
//  zpay
//
//  Created by Yassir Aberni on 06/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class DataManager {
    
    
    class func initData(token:String) {
        
       NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
        
        print(token)
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getToken() -> String {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("token") == nil {
            
            return ""
        }else{
            
            
            
            let token =  NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
            
            print(token)
            
            return token
            
        }
    }
}
