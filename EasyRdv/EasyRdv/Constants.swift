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
    
    static let urlServer:String = "http://192.168.15.247:8080"
    
    static let urlServerLocalHost:String = "http://localhost:8080"
    
    
    static let notificationmailpasswordok:String = "notificationmailpasswordok"
    
    
    
    static let notificationmailpassworderror:String = "notificationmailpassworderror"
    
    static let notificationeventupdateok:String = "notificationeventupdateok"
    static let notificationeventupdateokreload:String = "notificationeventupdateokreload"
    
    static let notificationeventupdateerror:String = "notificationeventupdateerror"

    
    
    static let notificationconxerror:String = "notificationconxerror"
    
    
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
    struct Formatter {
        static let custom = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZ")

    }
    var customFormatted: String {
        Formatter.custom.timeZone = NSTimeZone.localTimeZone()
        return Formatter.custom.stringFromDate(self)
    }
    
    var asDateString :String {
        
Formatter.custom.timeZone = NSTimeZone.localTimeZone()
        Formatter.custom.locale = NSLocale(localeIdentifier: "fr_FR")
        Formatter.custom.dateStyle = NSDateFormatterStyle.FullStyle
        Formatter.custom.timeStyle = NSDateFormatterStyle.ShortStyle
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components([.Weekday , .Month , .Year], fromDate: self)
//        let year =  components.year
//        let month = components.month
//        let day = components.weekday
//        let hour = components.hour
//        let minute = components.minute
//        let dateString = "\(day)\(month)"
        
        return Formatter.custom.stringFromDate(self)
    }
}
extension String {
    var asDate: NSDate? {
        
        return NSDate.Formatter.custom.dateFromString(self)
    }
    
    func asDateFormatted(with dateFormat: String) -> NSDate? {
        return NSDateFormatter(dateFormat: dateFormat).dateFromString(self)
    }
}

