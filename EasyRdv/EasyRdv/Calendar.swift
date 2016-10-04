//
//  Calendar.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class Calendar:NSObject {
    
    var listCalandar:NSMutableArray?
    
    override init() {
        super.init()
        listCalandar = NSMutableArray()
        
    }
    
    deinit {
        
        listCalandar = nil
    }
    
    
     init (eventInfos:[[String:AnyObject]]) {
        super.init()
        
        listCalandar = NSMutableArray()
       
        for eventInfo in eventInfos {
            
            let event:Event = Event(eventInfo: eventInfo)
            listCalandar?.addObject(event)
            
        }
        
    }
    
}
