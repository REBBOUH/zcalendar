//
//  UserSingleton.swift
//  zpay
//
//  Created by Yassir Aberni on 13/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class UserSingleton {
    
    var user = User()
    
    var userApp = UserApp()
    
    class var sharedInstance : UserSingleton {
        
        struct Singleton {
        
            static let userInstance = UserSingleton()
        }
        
        return Singleton.userInstance
    }
}
