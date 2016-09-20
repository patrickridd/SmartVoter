//
//  ElectionController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class ElectionController {
    
    static let sharedController = ElectionController()
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    static let baseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    static var electionDate = String()
    static var electionName = String()

    
    static func getContest(address: String, completion: ([Election]?) -> Void) {
        
        guard let url = baseURL else {
            completion(nil)
            return
        }
        
        let urlParameters = ["address":address,"key":apiKey]
        
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            guard let data = data,
                jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject] else {
//                electionDictionary = jsonDictionary["election"] as? [String:String],
//                date = electionDictionary["electionDay"],
//                electionName = electionDictionary["name"],
//                contestsDictionary = jsonDictionary["contests"] as? [String:AnyObject] else {
                    completion(nil)
                    return
            }
            
//            self.electionName = electionName
//            self.electionDate = date
//            print(electionName)
//            print(electionDate)
//            print(data)
        print(jsonDictionary)
            
        }
        
        
    }
    
    
    
    
    
}