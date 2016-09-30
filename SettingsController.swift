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
    
    
    func scheduleDayOfNotification() {
        let acceptNotification = ProfileController.sharedController.checkIfNotificationsAreEnabled()
        guard let date = ElectionController.electionDate, let electionDay = ElectionController.dateFormatter.dateFromString(date + "T00:00:00-00:00") else {
            return
        }
        
        // If the day of the election is before the present day, don't schedule the notification because it has already happened.
        if electionDay.timeIntervalSince1970 < NSDate().timeIntervalSince1970 || !acceptNotification {
            return
        }
        
        let localNotification = UILocalNotification()
        localNotification.alertTitle = "\(ElectionController.electionName)"
        localNotification.alertBody = "Don't forget to Vote Today"
        localNotification.category = "VoteTime"
        localNotification.fireDate = electionDay
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        ProfileController.sharedController.saveNotificationBool(true)
    }
    
    /// Shedules Notification one day before the Election.
    func scheduleOneDayNotification() {
        let acceptNotification = ProfileController.sharedController.checkIfNotificationsAreEnabled()
        guard let date = ElectionController.electionDate, let electionDay = ElectionController.dateFormatter.dateFromString(date + "T00:00:00-00:00") else {
            return
        }
        let dayBeforeElectionTimeInterval = electionDay.timeIntervalSinceNow - NSTimeInterval()*60*60*24
        let dayBeforeElection = NSDate(timeIntervalSinceReferenceDate: dayBeforeElectionTimeInterval)
        
        // If the day of the election is before the present day, don't schedule the notification because it has already happened.
        if dayBeforeElection.timeIntervalSince1970 < NSDate().timeIntervalSince1970 || !acceptNotification {
            return
        }
        
        let localNotification = UILocalNotification()
        localNotification.alertTitle = "\(ElectionController.electionName)"
        localNotification.alertBody = "Don't forget to Vote Today"
        localNotification.category = "VoteTime"
        localNotification.fireDate = dayBeforeElection
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        ProfileController.sharedController.saveNotificationBool(true)
    }
    
    /// Shedules Notification five days before the Election.
    func scheduleFiveDaysNotification() {
        
    }
    
    /// Shedules Notifications for five days before, one day before, and the day of the Election.
    func scheduleNotficationForAllOptions() {
        scheduleDayOfNotification()
        scheduleOneDayNotification()
        scheduleFiveDaysNotification()
    }

    
    
    
    
}
