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
    var candidates: [Official]?
    
    init?(dictionary: [String: AnyObject]) {
        guard let type = dictionary["type"] as? String,
            office = dictionary["office"] as? String,
            districtDictionary = dictionary["district"] as? [String : AnyObject],
            scope = districtDictionary["scope"] as? String,
            candidatesArray = dictionary["candidates"] as? [[String : AnyObject]] else { return nil }
        
        var candidates: [Official] = []
        
        for candidate in candidatesArray {
            guard let name = candidate["name"] as? String,
                party = candidate["party"] as? String,
                webAddress = candidate["candidateUrl"] as? String,
                phoneNumber = candidate["phone"] as? String,
                emailAddress = candidate["email"] as? String else { return nil }
            
            let official = Official()
            candidates.append(official)
        }
        
        self.type = type
        self.office = office
        self.scope = scope
        self.candidates = candidates
    }
}