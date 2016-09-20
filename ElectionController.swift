//
//  ElectionController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class ElectionController {
    
    var electionDate = NSDate()
    static let sharedController = ElectionController()
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    static let baseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    
    static func getContest(address: String, completion: ([Election]?) -> Void) {
        
        guard let url = baseURL else {
            completion(nil)
            return
        }
        
        let urlParameters = ["address":address,"key":apiKey]
        
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            print(data)
            
            
        }
        
        
    }
    
    
    
    
    
}