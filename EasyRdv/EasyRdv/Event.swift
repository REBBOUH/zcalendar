//
//  Event.swift
//  EasyRdv
//
//  Created by Yassir Aberni on 21/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation


class Event:NSObject {
    
    var id:String?
    var nom:String?
    var start:Date?
    var end:Date?
    var iCalUID:String?
    var descriptionEvent:String?
    var location:String?
    var organisateur:String?
    var iconId:String?
    
    override init() {
        super.init()
        self.initData()
    }
    deinit {
        self.initData()
    }
    init(eventInfo:[String:AnyObject]){
        super.init()
        initData()
        id = eventInfo["id"] as? String
        nom = eventInfo["summary"] as? String
        end = (eventInfo["end"]!["dateTime"] as? String)!.asDate as Date?
        start = (eventInfo["start"]!["dateTime"] as? String)!.asDate as Date?
        descriptionEvent = eventInfo["description"] as? String
        location = eventInfo["location"] as? String
        organisateur = eventInfo["creator"]!["email"] as? String
        iconId = eventInfo["colorId"] as? String
        //        print("evetn class----------------------")
        //        print("************calendar class \(eventInfo.description)")
        //        print("************ \(start)")
        //        print("************\(eventInfo["start"]!["dateTime"] as? String)!")
        //        print("************calendar class event Id \(id)")
        //        print("************calendar class icon Id \(iconId)")
        //        print("---------------------------")
        
    }
    
    func initData(){
        
        self.id = nil
        self.nom = nil
        self.start = nil
        self.end = nil
        self.iCalUID = nil
        self.descriptionEvent = nil
        self.location = nil
        self.organisateur = nil
        self.iconId = nil
        
    }
    
    
    func setValue(_ event:Event){
        
        self.id = event.id
        nom = event.nom
        end = event.end
        start = event.start
        descriptionEvent = event.descriptionEvent
        location = event.location
        organisateur = event.location
        
    }
   
    
}

