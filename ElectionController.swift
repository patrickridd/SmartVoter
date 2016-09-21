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
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    static var elections = [Contest]()
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    static let infoBaseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    static let electionURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/elections")
    static var electionDate = String()
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
                    let contests = contestsDictionary.flatMap{Contest(dictionary: $0, electionName: election.name, electionDay: election.electionDay)}
                    self.elections = contests
                    completion(contests)
                    
                    
                    guard let pollingLocationDictionary = jsonDictionary["pollingLocations"] as? [[String: AnyObject]] else {
                        return
                    }
                    
                    let pollingLocations = pollingLocationDictionary.flatMap({PollingLocation(jsonDictionary: $0)})
                    PollingLocationController.sharedController.pollingLocations = pollingLocations
                }
                
            }
        }
    }
    
    /// Schedules Notification of when the Election is
    func scheduleElectionNotification() {
        
        guard let date = dateFormatter.dateFromString(ElectionController.electionDate) else {
            return
        }
        
        let localNotification = UILocalNotification()
        localNotification.alertTitle = "\(ElectionController.electionName)"
        localNotification.alertBody = "Don't forget to Vote Today"
        localNotification.category = "VoteTime"
        localNotification.fireDate = date
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        
        
    }
    
    
    
    
    
    
    
    
    
    
}