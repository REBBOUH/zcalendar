//
//  Calendar.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 22/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class Calendar {
    
    var listCalandar:NSMutableArray?
    
    init() {
        
        listCalandar = NSMutableArray()
        
    }
    
    
     init (eventInfos:[[String:AnyObject]]) {
        
        listCalandar = NSMutableArray()
        
        for eventInfo in eventInfos {
            
            let event:Event = Event()
            
            event.initWithDic(eventInfo)
            
            listCalandar?.addObject(event)
        }
        print("----\(listCalandar?.count)")
    }
    
}
