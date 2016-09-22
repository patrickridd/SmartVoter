//
//  Office.swift
//  SmartVoter
//
//  Created by Steven Patterson on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation


struct Office {
    
    private let kName = "name"
    private let kIndicies = "officialIndices"
    private let kDivisionID = "divisionId"
    
    let name: String
    var indicies: [Int]
    var division: String
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary[kName] as? String,
            indicies = dictionary[kIndicies] as? [Int],
            divisionID = dictionary[kDivisionID] as? String else {return nil}
        
        self.indicies = indicies
        self.name = name
        self.division = divisionID
    }
}




