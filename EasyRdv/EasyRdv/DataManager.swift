//
//  DataManager.swift
//  zpay
//
//  Created by Yassir Aberni on 06/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class DataManager {
    
    
    class func initToken(_ token:String) {
        
        UserDefaults.standard.set(token, forKey: "token")
        
        print(token)
        
        UserDefaults.standard.synchronize()
    }
    
    class func getToken() -> String {
        
        if UserDefaults.standard.object(forKey: "token") == nil {
            
            
            return ""
        }else{
            
            let token =  UserDefaults.standard.object(forKey: "token") as! String
            
            print(token)
            
            return token
            
        }
    }
    
    class func getUserInfo() -> UserApp {
        
        var user:UserApp? = UserApp()
        
        if UserDefaults.standard.object(forKey: "userInfo") != nil {
            
            let userInfo =  UserDefaults.standard.object(forKey: "userInfo") as! [String:AnyObject]
            
            
             user  = UserApp(userInfo: userInfo)
          

        }
        
        return user!
    }
    
    class func initUserInfo(_ userInfo:[String:Any]){
        
        UserDefaults.standard.set(userInfo, forKey: "userInfo")
        
        print(userInfo)
        
        UserSingleton.sharedInstance.userApp = UserApp(userInfo: userInfo)
        
        print(UserSingleton.sharedInstance.userApp.name!)
       
        UserDefaults.standard.synchronize()

    }
}
