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
    
    let name: String
    var indicies: [Int]
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary[kName] as? String,
            indicies = dictionary[kIndicies] as? [Int] else {return nil}
        
        self.indicies = indicies
        self.name = name
        
    }
    
    
}