//
//  PollingLocation.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class PollingLocation {
    
    let addressKey = "address"
    let locationNameKey = "locationName"
    let streetNameKey = "line1"
    let cityKey = "city"
    let stateKey = "state"
    let zipKey = "zip"
    let pollingKey = "pollingHours"
    
    let streetName: String
    let city: String
    let state: String
    let zip: String
    var locationName: String
    var pollingHours: String
    
    init(address: String, city: String, state: String, zip: String, locationName: String, pollingHours: String) {
        self.streetName = address
        self.city = city
        self.state = state
        self.zip = zip
        self.locationName = locationName
        self.pollingHours = pollingHours
        
    }
    
    init?(jsonDictionary: [String:AnyObject]) {
        guard let addressDictionary = jsonDictionary[addressKey] as? [String:String],
            locationName = addressDictionary[locationNameKey],
            streetName = addressDictionary[streetNameKey],
            city = addressDictionary[cityKey],
            state = addressDictionary[stateKey],
            zip = addressDictionary[zipKey],
            pollingHours = jsonDictionary[pollingKey] as? String else {
                return nil
        }
        
        self.streetName = streetName
        self.city = city
        self.state = state
        self.zip = zip
        self.locationName = locationName
        self.pollingHours = pollingHours
        
    }
}