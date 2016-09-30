//
//  ElectionController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation
import UIKit

class ElectionController {
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
   static let dateToStringFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .LongStyle
        return formatter
    }()
    static var contests = [Contest]()
    static var sortedContests: [[Contest]] {
        var elections: [Contest] = []
        var referendums: [Contest] = []
        for contest in contests {
            if contest.type == "General" {
                elections.append(contest)
            } else if contest.type == "Referendum" {
                referendums.append(contest)
            }
        }
        return [elections, referendums]
    }
    
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    static let infoBaseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    static let electionURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/elections")
    static var electionDate: String?
    static var electionName = String()
    static var pollingLocation = [String]()
    
    
    /// Gets an Array of upcomming elections for ElectionTableViewController
    static func getContest(address: String, completion: ([Contest]?) -> Void) {
        
        guard let electionURL = electionURL else {
            completion(nil)
            return
        }
        
        let parameters = ["key":apiKey]
        
        NetworkController.performRequestForURL(electionURL, httpMethod: .Get, urlParameters: parameters, body: nil) { (data, error) in
            guard let data = data, jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)),
                electionsArray = jsonDictionary["elections"] as? [[String:String]] else {
                    return
            }
            
            
            let elections = electionsArray.flatMap{Election(jsonDictionary: $0)}
            
            for election in elections {
                if election.id == "2000" || election.name.lowercaseString.containsString("test") {
                    continue
                }
                guard let url = infoBaseURL else {
                    completion(nil)
                    return
                }
                
                let urlParameters = ["address":"\(address)", "electionId":election.id,"key":"\(apiKey)"]
                
                NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
                    guard let data = data,
                        jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject],
                        electionDictionary = jsonDictionary["election"] as? [String:String],
                        date = electionDictionary["electionDay"],
                        electionName = electionDictionary["name"],
                        contestsDictionary = jsonDictionary["contests"] as? [[String:AnyObject]] else {
                            completion(nil)
                            return
                    }
                    
                    self.electionDate = date
                    self.electionName = electionName
                    if let notificationIsSet = ProfileController.sharedController.loadNotificationStatus() {
                        if !notificationIsSet {
                            scheduleElectionNotification()
                        }
                    } else {
                        self.scheduleElectionNotification()
                    }
                    let contests = contestsDictionary.flatMap{Contest(dictionary: $0, electionName: election.name, electionDay: election.electionDay)}
                    self.contests = contests
                    completion(contests)
                    
                }
                // Gets Voter Registration URL
                guard let stateDictionary = jsonDictionary["state"] as? [[String:AnyObject]] else {
                    return
                }
                if stateDictionary.count > 0 {
                    let stateArray = stateDictionary[0]
                    guard let electionBodyDictionary = stateArray["electionAdministrationBody"] as? [String:AnyObject],
                        let registrationURL = electionBodyDictionary["electionRegistrationUrl"] as? String else {
                            return
                    }
                    ProfileController.sharedController.saveRegisterToVoteURL(registrationURL)
                }   
            }
        }
    }
    
    /// Schedules Notification of when the Election is
    static func scheduleElectionNotification() {
        let acceptNotification = ProfileController.sharedController.checkIfNotificationsAreEnabled()
        guard let date = dateFormatter.dateFromString(ElectionController.electionDate! + "T00:00:00-00:00") else {
            return
        }
        
        // If the day of the election is before the present day, don't schedule the notification because it has already happened.
        if date.timeIntervalSince1970 < NSDate().timeIntervalSince1970 || !acceptNotification {
            return
        }
        
        let localNotification = UILocalNotification()
        localNotification.alertTitle = "\(ElectionController.electionName)"
        localNotification.alertBody = "Don't forget to Vote Today"
        localNotification.category = "VoteTime"
        localNotification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        ProfileController.sharedController.saveNotificationBool(true)
        
    }
    
    
    
    
    
    
    
    
    
    
}
