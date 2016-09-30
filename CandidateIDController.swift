//
//  CandidateIDController.swift
//  SmartVoter
//
//  Created by Steven Patterson on 9/30/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class CandidateIDController {
    
    static let sharedController = CandidateIDController()
    static let apiKey = "37ae7a868a4d18f7a8bb41383e006cb1"
    static let baseURL = NSURL(string: "http://www.opensecrets.org/api/?method=getLegislators")
    
    static func getCandidateID(id: String, completion: ()-> Void) {
        guard let url = baseURL else{
            print("NO URL FOUND (CandidateIDController)")
            return
        }
        let urlParameters = ["id": id, "apikey": apiKey]
        
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            guard let data = data,
                responseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                    print("No Data Found")
                    return
            }
            guard let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: AnyObject],
                responseDictionary = jsonDictionary["response"] as? [String: AnyObject],
                legislatorDictionary = responseDictionary["legislator"] as? [[String: AnyObject]] else {
                    print("Unable to Serialize JSON: \(responseDataString)")
                    return }
            
            let candidateIDs = legislatorDictionary.flatMap{CandidateID(dictionary: $0)}
            let canidateID = candidateIDs
        }
    }
}
