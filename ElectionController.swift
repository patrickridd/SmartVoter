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
    
    static var elections = [Election]()
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    static let baseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    static var electionDate = String()
    static var electionName = String()
    static var pollingLocation = [String]()
    
    
    
    static func getContest(address: String, completion: ([Election]?) -> Void) {
        
        guard let url = baseURL else {
            completion(nil)
            return
        }
        
        let urlParameters = ["address":"\(address)", "electionId": "2000","key":"\(apiKey)"]
        
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
            let contests = contestsDictionary.flatMap{Election(dictionary: $0)}
            completion(contests)
            self.elections = contests
            print(contests)
            
            
            guard let pollingLocationDictionary = jsonDictionary["pollingLocations"] as? [[String: AnyObject]] else {
                return
            }
            
            let pollingLocations = pollingLocationDictionary.flatMap({PollingLocation(jsonDictionary: $0)})
            PollingLocationController.sharedController.pollingLocations = pollingLocations
        }
        
        
    }
    
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