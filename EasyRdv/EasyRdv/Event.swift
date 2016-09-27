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
    var start:NSDate?
    var end:NSDate?
    var iCalUID:String?
    var descriptionEvent:String?
    var location:String?
    var organisateur:String?
    
   
   func  initWithDic(eventInfo:[String:AnyObject]){
        id = eventInfo["id"] as? String
        nom = eventInfo["summary"] as? String
        end = (eventInfo["end"]!["dateTime"] as? String)!.asDate
        start = (eventInfo["start"]!["dateTime"] as? String)!.asDate
        descriptionEvent = eventInfo["description"] as? String
        location = eventInfo["location"] as? String
         organisateur = eventInfo["creator"]!["email"] as? String
    }
    func setValue(event:Event){
        self.id = event.id
        nom = event.nom
        end = event.end
        start = event.start
        descriptionEvent = event.descriptionEvent
        location = event.location
        organisateur = event.location

    }

}

/*{
 "kind": "calendar#event",
 "etag": "\"2948857996864000\"",
 "id": "gvhjfkodf8rnh1lvt5s2sei5hs",
 "status": "confirmed",
 "htmlLink": "https://www.google.com/calendar/event?eid=Z3ZoamZrb2RmOHJuaDFsdnQ1czJzZWk1aHMgenNvZnQtY29uc3VsdGluZy5jb21fMXFvY2I1cW1hM2NncnNqcjhhb2YxZTVuMDRAZw",
 "created": "2016-09-20T16:27:25.000Z",
 "updated": "2016-09-21T14:45:22.707Z",
 "summary": "Dispo",
 "location": "paris ",
 "creator": {
 "email": "yassir.aberni@zsoft-consulting.com"
 },
 "organizer": {
 "email": "zsoft-consulting.com_1qocb5qma3cgrsjr8aof1e5n04@group.calendar.google.com",
 "displayName": "pro",
 "self": true
 },
 "start": {
 "dateTime": "2016-09-23T12:00:00+02:00"
 },
 "end": {
 "dateTime": "2016-09-23T13:00:00+02:00"
 },
 "iCalUID": "gvhjfkodf8rnh1lvt5s2sei5hs@google.com",
 "sequence": 2,
 "hangoutLink": "https://plus.google.com/hangouts/_/zsoft-consulting.com/yassir-aberni?hceid=eWFzc2lyLmFiZXJuaUB6c29mdC1jb25zdWx0aW5nLmNvbQ.gvhjfkodf8rnh1lvt5s2sei5hs",
 "reminders": {
 "useDefault": false,
 "overrides": [
 {
 "method": "popup",
 "minutes": 10
 }
 ]
 }*/
