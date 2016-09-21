//
//  Election.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/21/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

struct Election {
    
    let nameKey = "name"
    let idKey = "id"
    let dayKey = "electionDay"
    
    let name: String
    let electionDay: String
    let id: String
    
    init?(jsonDictionary: [String:String]) {
        guard let name = jsonDictionary[nameKey],
            electionDay = jsonDictionary[dayKey],
            id = jsonDictionary[idKey] else {
                return nil
        }
        
        self.name = name
        self.electionDay = electionDay
        self.id = id

    }
    
}