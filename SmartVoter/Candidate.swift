//
//  Candidate.swift
//  SmartVoter
//
//  Created by Brad on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class Candidate {
    
    var name: String
    var party: String?
    var websiteURL: String?
    var phone: String?
    var email: String?
    
    init(name: String, party: String?, websiteURL: String?, phone: String?, email: String?) {
        self.name = name
        self.party = party
        self.websiteURL = websiteURL
        self.phone = phone
        self.email = email
    }
}