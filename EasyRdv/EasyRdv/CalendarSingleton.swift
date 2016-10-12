//
//  UserSingleton.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 13/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class CalendarSingleton {
    
    var event:Event = Event()
    
    
    
    class var sharedInstance : CalendarSingleton {
        
        struct Singleton {
        
            static let userInstance = CalendarSingleton()
        }
        
        return Singleton.userInstance
    }
}
