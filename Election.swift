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
    var office: String?
    var scope: String
    var candidates: [Candidate]?
    
    init?(dictionary: [String: AnyObject]) {
        guard let type = dictionary["type"] as? String,
            office = dictionary["office"] as? String,
            districtDictionary = dictionary["district"] as? [String : AnyObject],
            scope = districtDictionary["scope"] as? String,
            candidatesArray = dictionary["candidates"] as? [[String : AnyObject]] else { return nil }
        
        var candidates: [Candidate] = []
        
        for candidateDictionary in candidatesArray {
            guard let name = candidateDictionary["name"] as? String else {
                return nil
            }
            
            
            let party = candidateDictionary["party"] as? String
            let  webAddress = candidateDictionary["candidateUrl"] as? String
            let phoneNumber = candidateDictionary["phone"] as? String
            let emailAddress = candidateDictionary["email"] as? String
            
            let candidate = Candidate(name: name, party: party, websiteURL: webAddress, phone: phoneNumber, email: emailAddress)
            candidates.append(candidate)
        }
        
        self.type = type
        self.office = office
        self.scope = scope
        self.candidates = candidates
    }
}