//
//  OfficialController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class OfficialController {
    
    static let sharedController = OfficialController()
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"
    static let officialIndicesKey = "officialIndices"
    
    static let baseURl = NSURL(string: "https://www.googleapis.com/civicinfo/v2/representatives?")
    static var officials: [Official] = []
    static var offices: [Office] = []
    
    
    static func getOfficials(address: String, completion: ()-> Void) {
        guard let url = baseURl else {
            print("Sorry No URL found")
            return
        }
        let urlParameters = ["key" : OfficialController.apiKey, "address" : address ]
        
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            guard let data = data,
                responseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                    print("No Data Found")
                    return
            }
            
            guard let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: AnyObject],
            officesArrayOfDictionaries = jsonDictionary["offices"] as? [[String: AnyObject]], officials = jsonDictionary["officials"] as? [[String:AnyObject]]
            else {
                print("Unable to Serialize JSON: \(responseDataString)")
                return}
    
            let offices = officesArrayOfDictionaries.flatMap{Office(dictionary: $0)}
            self.offices = offices
            var officiales = [Official]()
            
            for i in offices {
                for officialsIndex in i.indicies {
                    let officialDictionary = officials[officialsIndex]
                    if let newOfficial = Official(dictionary: officialDictionary, office: i.name) {
                        officiales.append(newOfficial)
                    }
                }
            }
            OfficialController.officials = officiales
            completion()
        }
    }
}