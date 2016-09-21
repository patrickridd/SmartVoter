//
//  Election.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class Election {
    
    var type: String
    var scope: String
    var office: String?
    var candidates: [Candidate]?
    var referendumTitle: String?
    var referendumSubtitle: String?
    var referendumUrl: String?
    
    init?(dictionary: [String: AnyObject]) {
        guard let type = dictionary["type"] as? String,
            districtDictionary = dictionary["district"] as? [String : AnyObject],
            scope = districtDictionary["scope"] as? String else { return nil }
        
        if type == "General" {
            let office = dictionary["office"] as? String
            
            self.office = office
            
        } else if type == "Referendum" {
            let referendumTitle = dictionary["referendumTitle"] as? String
            let referendumSubtitle = dictionary["referendumSubtitle"] as? String
            let referendumUrl = dictionary["referendumUrl"] as? String
            
            self.referendumTitle = referendumTitle
            self.referendumSubtitle = referendumSubtitle
            self.referendumUrl = referendumUrl
        }
        
        var candidates: [Candidate] = []
        
        if let candidatesArray = dictionary["candidates"] as? [[String : AnyObject]] {
            for candidateDictionary in candidatesArray {
                guard let name = candidateDictionary["name"] as? String else {
                    return nil
                }
                
                let party = candidateDictionary["party"] as? String
                let webAddress = candidateDictionary["candidateUrl"] as? String
                let phoneNumber = candidateDictionary["phone"] as? String
                let emailAddress = candidateDictionary["email"] as? String
                
                let candidate = Candidate(name: name, party: party, websiteURL: webAddress, phone: phoneNumber, email: emailAddress)
                candidates.append(candidate)
            }
        }
        
        self.type = type
        self.scope = scope
        self.candidates = candidates
    }
}













