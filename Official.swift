//
//  Official.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

struct Official {

    private let kOfficial = "officials"
    private let kName = "name"
    private let kAddress = "address"
    private let kAddressLine1 = "line1"
    private let kAddressCity = "city"
    private let kAddressState = "state"
    private let kAddressZip = "zip"

    

    
    var name: String?
    var party: String?
    var address: String?
    var phone: String?
    var webAddress: String?
    var photo: String?
    
    init?(dictionary: [String: AnyObject])  {
        
        guard let name = dictionary[kName] as? String else { return nil }

        guard let  address = dictionary[kAddress] as? [String: AnyObject],
            line1 = address[kAddressLine1] as? String,
            city = address[kAddressCity] as? String,
            state = address[kAddressState] as? String,
            zip = address[kAddressZip] as? String else { return nil }
        
        guard let party = dictionary[kParty] as? String
        
    
    }
    
}