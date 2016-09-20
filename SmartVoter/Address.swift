//
//  Address.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

struct Address {

    var line1: String
    var city: String
    var state: String
    var zip: String
    
    var asAString: String {
        return "\(line1), \(city.capitalizedString), \(state), \(zip)"
    }
    
    init(line1: String, city: String, state: String, zip: String) {
        self.line1 = line1
        self.city = city
        self.state = state
        self.zip = zip
    }
}