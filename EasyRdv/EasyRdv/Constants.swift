//
//  Constants.swift
//  zpay
//
//  Created by Yassir Aberni on 06/09/2016.
//  Copyright © 2016 Yassir Aberni. All rights reserved.
//

import Foundation



struct Constants {
    
    static let username:String = "yassir"
    
    static let password:String = "aberni"
    
   // static let urlServer:String = "http://192.168.15.247:8080"
    
    static let urlServer:String = "http://localhost:8080"
    
    static let urlServercheck:String = "\(Constants.urlServer)/check/"
    
    static let urlServerUpdateEvent:String = "\(Constants.urlServer)/update/"
    
    static let urlServerchecklist:String = "\(Constants.urlServer)/checklist"
    
    
//    static let urlServercheck:String = "http://192.168.15.247:8080/check/"
//    
//    static let urlServerUpdateEvent:String = "http://192.168.15.247:8080/update/"
//    
//    static let urlServerchecklist:String = "http://192.168.15.247:8080/checklist"
    
    //MARK: - Notification String
    // user notification
    static let notificationusergetok:String = "notificationusergetok"
    static let notificationusergeterror:String = "notificationusergeterror"
    //event notifcation
    static let notificationmailpasswordok:String = "notificationmailpasswordok"
    static let notificationmailpassworderror:String = "notificationmailpassworderror"
    static let notificationeventupdateok:String = "notificationeventupdateok"
    static let notificationeventupdateokreload:String = "notificationeventupdateokreload"
    static let notificationeventupdateerror:String = "notificationeventupdateerror"
    static let notificationconxerror:String = "notificationconxerror"
    static let notificationeventconxerror:String = "notificationeventconxerror"
    
    
}

extension NSNotificationCenter {
    
    func setObserver(observer: AnyObject, selector: Selector, name: String?, object: AnyObject?) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: name, object: object)
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: name, object: object)
    }
}

extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
        self.timeZone = NSTimeZone.localTimeZone()
    }
}

extension NSDate {
    
    var customFormatted: String {
        let custom = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        custom.timeZone = NSTimeZone.localTimeZone()
        return custom.stringFromDate(self)
    }
    
    var asDateString :String {
        let custom = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        custom.timeZone = NSTimeZone.localTimeZone()
         custom.locale = NSLocale(localeIdentifier: "fr_FR")
        custom.dateStyle = NSDateFormatterStyle.FullStyle
        custom.timeStyle = NSDateFormatterStyle.ShortStyle
       
        
        return custom.stringFromDate(self)
    }
}
extension String {
    var asDate: NSDate? {
       let custom = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")
        return custom.dateFromString(self)
    }
    
    func asDateFormatted(with dateFormat: String) -> NSDate? {
        return NSDateFormatter(dateFormat: dateFormat).dateFromString(self)
    }
}

