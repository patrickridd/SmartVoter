//
//  SettingsController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/29/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation
import UIKit

class SettingsController {
    
    static let sharedController = SettingsController()
    static let calendar = NSCalendar.currentCalendar()
    
    
    
    let urlKey = "urlKey"
    let addressKey = "addressKey"
    let notificationBoolKey = "notificationBoolKey"
    let notificationSettingKey = "notificationSettingKey"
    
    static let infoBaseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    static let electionURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/elections")
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    var notificationIsSet: Bool?
    static var electionDay = String()
    static var electionName = String()
    
    
    enum NotificationSetting: String {
        case dayOf = "dayOf"
        case oneDay = "oneDay"
        case oneWeek = "oneWeek"
        case all = "all"
    }
    
    
    /// Saves a notification setting
    func saveNotificationSetting(notificationSetting: NotificationSetting) {
        let setting = notificationSetting.rawValue
        NSUserDefaults.standardUserDefaults().setObject(setting, forKey: notificationSettingKey)
    }
    
    /// Loads notification settings
    func loadNotificationSetting() -> String {
        if let setting = NSUserDefaults.standardUserDefaults().objectForKey(notificationSettingKey) as? String {
            
            switch setting {
            case NotificationSetting.dayOf.rawValue:
                return NotificationSetting.dayOf.rawValue
            case NotificationSetting.oneDay.rawValue:
                return NotificationSetting.oneDay.rawValue
            case NotificationSetting.oneWeek.rawValue:
                return NotificationSetting.oneWeek.rawValue
            default:
                return NotificationSetting.all.rawValue
            }
        } else {
            return "NoSettingSet"
        }
    }
    
    func checkIfNotificationsAreEnabled() -> Bool {
        let settings =  UIApplication.sharedApplication().currentUserNotificationSettings()
        if settings?.types == UIUserNotificationType.None {
            return false
        } else {
            return true
        }
    }
    
    
    /// Loads notification bool to see if it has been set or not
    func loadNotificationStatus() -> Bool? {
        let status: Bool? = NSUserDefaults.standardUserDefaults().objectForKey(notificationBoolKey) as? Bool
        self.notificationIsSet = status
        return self.notificationIsSet ?? nil
    }
    
    
    
    /// Network Call to get polling Locations.
    static func getElectionDate(address: Address, completion: () -> Void) {
        guard let electionURL = electionURL else {
            completion()
            return
        }
        
        let parameters = ["key":apiKey]
        
        NetworkController.performRequestForURL(electionURL, httpMethod: .Get, urlParameters: parameters, body: nil) { (data, error) in
            guard let data = data, jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)),
                electionsArray = jsonDictionary["elections"] as? [[String:String]] else {
                    completion()
                    return
            }
            let elections = electionsArray.flatMap{Election(jsonDictionary: $0)}
            
            for election in elections {
                
                guard let url = infoBaseURL else {
                    completion()
                    return
                }
                let urlParameters = ["address":"\(address.asAString)", "electionId":election.id,"key":"\(apiKey)"]
                
                NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
                    guard let data = data,
                        jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject], electionDictionary = jsonDictionary["election"] as? [String:String],
                        date = electionDictionary["electionDay"],
                        electionName = electionDictionary["name"] else {
                            completion()
                            return
                    }
                    
                    self.electionDay = date
                    self.electionName = electionName
                    completion()
                }
            }
        }
    }
    
        
        static func scheduleDayOfNotification() {
            let acceptNotification = ProfileController.sharedController.checkIfNotificationsAreEnabled()
              guard let electionDay = ElectionController.dateFormatter.dateFromString(self.electionDay + "T00:00:00-00:00") else {
                    return
            }
            
            // If the day of the election is before the present day, don't schedule the notification because it has already happened.
            if electionDay.timeIntervalSince1970 < NSDate().timeIntervalSince1970 || !acceptNotification {
                return
            }
            
            let localNotification = UILocalNotification()
            localNotification.alertTitle = "\(ElectionController.electionName)"
            localNotification.alertBody = "Don't Forget To Vote Today"
            localNotification.category = "VoteTime"
            localNotification.fireDate = electionDay
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            ProfileController.sharedController.saveNotificationSetting(.dayOf)
        }
        
        /// Shedules Notification one day before the Election.
        static func scheduleOneDayNotification() {
            let acceptNotification = ProfileController.sharedController.checkIfNotificationsAreEnabled()
            guard let electionDay = ElectionController.dateFormatter.dateFromString(self.electionDay + "T00:00:00-00:00"), let dayBeforeElection = calendar.dateByAddingUnit(.Day, value: -1, toDate: electionDay, options: []) else {
                return
            }
            
            
            // If the day of the election is before the present day, don't schedule the notification because it has already happened.
            if dayBeforeElection.timeIntervalSince1970 < NSDate().timeIntervalSince1970 || !acceptNotification {
                return
            }
            
            let localNotification = UILocalNotification()
            localNotification.alertTitle = "\(ElectionController.electionName)"
            localNotification.alertBody = "Tomorrow Is The Election Don't Forget To Vote"
            localNotification.category = "TomorrowVoteTime"
            localNotification.fireDate = dayBeforeElection
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            ProfileController.sharedController.saveNotificationSetting(.oneDay)
        }
        
        /// Shedules Notification five days before the Election.
        static func scheduleOneWeekNotification() {
            let acceptNotification = ProfileController.sharedController.checkIfNotificationsAreEnabled()
            guard let electionDay = ElectionController.dateFormatter.dateFromString(self.electionDay + "T00:00:00-00:00"), let oneWeekBeforeElection = calendar.dateByAddingUnit(.Day, value: -7, toDate: electionDay, options: []) else {
                return
            }
            
            
            // If the day of the election is before the present day, don't schedule the notification because it has already happened.
            if oneWeekBeforeElection.timeIntervalSince1970 < NSDate().timeIntervalSince1970 || !acceptNotification {
                return
            }
            
            let localNotification = UILocalNotification()
            localNotification.alertTitle = "\(ElectionController.electionName)"
            localNotification.alertBody = "One Week Before The Election Don't Forget To Vote"
            localNotification.category = "TomorrowVoteTime"
            localNotification.fireDate = oneWeekBeforeElection
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            ProfileController.sharedController.saveNotificationSetting(.oneWeek)
        }
        
        /// Shedules Notifications for five days before, one day before, and the day of the Election.
        static func scheduleNotficationForAllOptions() {
            scheduleDayOfNotification()
            scheduleOneDayNotification()
            scheduleOneWeekNotification()
            ProfileController.sharedController.saveNotificationSetting(.all)
        }
        
        
        
        
        
        
        
}
