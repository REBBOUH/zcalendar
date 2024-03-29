//
//  Constants.swift
//  zpay
//
//  Created by Yassir Aberni on 06/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation
import UIKit


struct Constants {
    
    static let username:String = "yassir"
    
    static let password:String = "aberni"
    
    static let urlServer:String = "http://192.168.15.180:8080"
    
   //static let urlServer:String = "http://localhost:8080"
    
    static let urlServercheck:String = "\(Constants.urlServer)/api/calendar/check/"
    
    static let urlServerUpdateEvent:String = "\(Constants.urlServer)/api/calendar/update/"
    
    static let urlServerchecklist:String = "\(Constants.urlServer)/api/calendar/checklist"
    
    static let urlServerAuthenticate:String = "\(Constants.urlServer)/api/authenticate"
    
    static let urlServerConnect:String = "\(Constants.urlServer)/api/connect"
    
//    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtYWlsIjoieWFzc2lyYWJlcm5pQGFiZXJuaXpzb2Z0LmZyIiwicGFzc3dvcmQiOiJ0ZXN0MSIsImlhdCI6MTQ3NTU5NzE1NX0.dCPq1MTzjeql6mn46-_I9Rj8dwrcMf5fQuoKo7HimEM"
    
    
//    static let urlServercheck:String = "http://192.168.15.247:8080/check/"
//    
//    static let urlServerUpdateEvent:String = "http://192.168.15.247:8080/update/"
//    
//    static let urlServerchecklist:String = "http://192.168.15.247:8080/checklist"
    
    //MARK: - Notification String
    // user notification
    static let notificationusergetok = NSNotification.Name("notificationusergetok")
    static let notificationusergetallok = NSNotification.Name("notificationusergetallok")
    static let notificationusergeterror =  NSNotification.Name("notificationusergeterror")
    //event notifcation
    static let notificationcalendarok =  NSNotification.Name("notificationcalendarok")
    static let notificationcalendarerror =  NSNotification.Name("notificationcalendarerror")
    static let notificationeventupdateok =  NSNotification.Name("notificationeventupdateok")
    static let notificationeventupdateokreload =  NSNotification.Name("notificationeventupdateokreload")
    static let notificationeventupdateerror =  NSNotification.Name("notificationeventupdateerror")
    static let notificationconxerror =  NSNotification.Name("notificationconxerror")
    static let notificationeventconxerror =  NSNotification.Name("notificationeventconxerror")
    
    static let notificationuseraddok =  NSNotification.Name("notificationuseraddok")
    static let notificationuseradderror =  NSNotification.Name("notificationuseradderror")
    
    static let titleCell:[[String]] = [["Accueil"],[UserSingleton.sharedInstance.userApp.name!,"Mes rendez-vous"],["Nous contacter"],["Déconnexion"]]
    static let SectionCell:[String] = ["","MON ESPACE","A PROPOS",""]
    static let imageCell:[[String]] = [["accueil"],["user","calendar"],["phone"],["shutdown"]]
    
    
}

extension NotificationCenter {
    
    func setObserver(_ observer: AnyObject, selector: Selector, name: Notification.Name?, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
        self.timeZone = TimeZone.autoupdatingCurrent
    }
}

extension Date {
    
    var customFormatted: String {
        let custom = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        custom.timeZone = TimeZone.autoupdatingCurrent
        return custom.string(from: self)
    }
    
    var asDateString :String {
        let custom = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        custom.timeZone = TimeZone.autoupdatingCurrent
         custom.locale = Locale(identifier: "fr_FR")
        custom.dateStyle = DateFormatter.Style.full
        custom.timeStyle = DateFormatter.Style.short
       
        
        return custom.string(from: self)
    }
}
extension String {
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
        
        var filtered:NSString!
        
        let inputString:NSArray = self.components(separatedBy: charcter) as NSArray
        
        filtered = inputString.componentsJoined(by: "")  as NSString!
        
        
        return  self == "\(filtered.description)"
        
        
    }
    
    var asDate: Date {
       let custom = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        return custom.date(from: self)!
    }
    
    func asDateFormatted(with dateFormat: String) -> Date? {
        return DateFormatter(dateFormat: dateFormat).date(from: self)
    }


}
extension Notification.Name {
    static let notificationusergetok = NSNotification.Name("notificationusergetok")
     static let notificationusergetallok = NSNotification.Name("notificationusergetallok")
    static let notificationusergeterror =  NSNotification.Name("notificationusergeterror")
    //event notifcation
    static let notificationcalendarok =  NSNotification.Name("notificationcalendarok")
    static let notificationcalendarerror =  NSNotification.Name("notificationcalendarerror")
    static let notificationeventupdateok =  NSNotification.Name("notificationeventupdateok")
    static let notificationeventupdateokreload =  NSNotification.Name("notificationeventupdateokreload")
    static let notificationeventupdateerror =  NSNotification.Name("notificationeventupdateerror")
    static let notificationconxerror =  NSNotification.Name("notificationconxerror")
    static let notificationeventconxerror =  NSNotification.Name("notificationeventconxerror")
    
    static let notificationuseraddok =  NSNotification.Name("notificationuseraddok")
    static let notificationuseradderror =  NSNotification.Name("notificationuseradderror")
    static let removefromUserCalendar =  NSNotification.Name("removefromUserCalendar")
    
}



