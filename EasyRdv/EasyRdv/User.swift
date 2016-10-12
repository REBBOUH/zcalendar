//
//  User.swift
//  zpay
//
//  Created by Yassir Aberni on 13/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation

class User {
    
    var nameUser:String?
    
    var calendarId:String?
    
    var descriptionUser:String?
    
    var adress:String?
    
    func initData() {
        
        self.nameUser = nil
        self.calendarId = nil
        self.descriptionUser = nil
       self.adress = nil
    }
    
    func initWithDic(_ _ userInfo:[String:AnyObject]){
      
        self.nameUser = userInfo["summary"] as? String
        self.calendarId = userInfo["id"] as? String
        self.descriptionUser = userInfo["description"] as? String
       self.adress = userInfo["location"] as? String
    }
    
    func checkAllValues() -> Bool {
        return self.nameUser != nil && self.calendarId != nil && self.descriptionUser != nil
    }
}

/*
 [ { kind: 'calendar#calendarListEntry',
 etag: '"1475077082868000"',
 id: 'zsoft-consulting.com_cdsdoimbkgpio7diamag2fh9es@group.calendar.google.com',
 summary: 'mourad Aissou',
 location: '10 Rue Taylor Paris 75010',
 timeZone: 'Europe/Paris',
 colorId: '2',
 backgroundColor: '#d06b64',
 foregroundColor: '#000000',
 selected: true,
 accessRole: 'owner',
 defaultReminders: [] } ]*/
