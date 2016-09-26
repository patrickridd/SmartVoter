//
//  ProfileController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class ProfileController {
    
    let urlKey = "urlKey"
    let addressKey = "addressKey"
    
    
    static var electionWebsite: String?
    static var electionPhoneNumber: String?
    var address: Address?
    static let sharedController = ProfileController()
    static let infoBaseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/voterinfo")
    static let electionURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/elections")
    static let apiKey = "AIzaSyCJoqWI3cD5VRDcWzThID1ATEweZ5R7j9I"

    
    
    // Saves User's Home Address to NSUserDefaults
    func saveAddressToUserDefault(address: Address) {
        self.address = address
        let data = NSKeyedArchiver.archivedDataWithRootObject(address)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: addressKey)
    }
    
    // Saves Voting Registration URL to NSUserDefaults
    func saveRegisterToVoteURL(url: String) {
        NSUserDefaults.standardUserDefaults().setObject(url, forKey: urlKey)
    }
    
    
    // Loads Users Address
    func loadAddress() ->Address? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(addressKey) as? NSData {
        let address = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Address
            self.address = address
            return address
        } else {
            return nil
        }
    }
    
    // Loads Voting Registration URL
    func loadURL() -> String? {
        let url = NSUserDefaults.standardUserDefaults().objectForKey(urlKey) as? String
        return url ?? nil
    }
    
    func formatNumberForCall(number: String) -> String {
        let phoneWhite = number.lowercaseString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).joinWithSeparator(" ")
        let noPunc =  phoneWhite.componentsSeparatedByCharactersInSet(NSCharacterSet.punctuationCharacterSet()).joinWithSeparator("")
        let noSpaces = noPunc.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return noSpaces
    }

    
    
    /// Network Call to get polling Locations.
    static func getPollingAddress(address: Address, completion: () -> Void) {
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
                        jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject] else {
                            completion()
                            return
                    }
                    if let pollingLocationDictionary = jsonDictionary["pollingLocations"] as? [[String: AnyObject]]  {
                        let pollingLocations = pollingLocationDictionary.flatMap({PollingLocation(jsonDictionary: $0)})
                        PollingLocationController.sharedController.pollingLocations = pollingLocations
                        completion()
                    }
                
                    
                    guard let stateDictionary = jsonDictionary["state"] as? [[String:AnyObject]] else {
                        completion()
                        return
                    }
                    if stateDictionary.count > 0 {
                        let stateArray = stateDictionary[0]
                        guard let electionBodyDictionary = stateArray["electionAdministrationBody"] as? [String:AnyObject],
                            let registrationURL = electionBodyDictionary["electionRegistrationUrl"] as? String else {
                                completion()
                                return
                        }
                        if let electionWebsite = electionBodyDictionary["electionInfoUrl"] as? String {
                            self.electionWebsite = electionWebsite
                        }
                        
                        if let electionJurisdiction = stateArray["local_jurisdiction"] as? [String:AnyObject],
                        let electionDictionary = electionJurisdiction["electionAdministrationBody"] as? [String:AnyObject],
                            let officialsArray = electionDictionary["electionOfficials"] as? [[String:AnyObject]] {
                            for official in officialsArray {
                                let number = official["officePhoneNumber"] as? String
                                self.electionPhoneNumber = number

                            }
                            
                        }
                        
                        ProfileController.sharedController.saveRegisterToVoteURL(registrationURL)
                        completion()
                    }

                    
                
                }
                
                
            }
        }
    }
    
    
}
