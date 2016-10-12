//
//  UserApp.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 10/10/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class UserApp {
    
    var id:String?
    var name:String?
    var mail:String?
    var number:String?
    var isClient:Bool?
    
    
    func initData() {
        
        self.id = nil
        self.name = nil
        self.mail = nil
        self.number = nil
        self.isClient = nil
    }
    init() {
initData()
    }
    init(userInfo:[String:Any]){
        
        self.name = userInfo["name"] as? String
        self.mail = userInfo["mail"] as? String
        self.id = userInfo["_id"] as? String
        self.number = userInfo["number"] as? String
        self.isClient = userInfo["isClient"] as? Bool
    }
    
    func checkAllValues() -> Bool {
        return self.number != nil && self.name != nil && self.isClient != nil && self.id == nil
    }
}

