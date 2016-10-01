//
//  CandidateID.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/29/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation


class CandidateID {
    
    private let kFullName = "fistlast"
    private let kID = "cid"
    private let kResponse = "response"
    private let kAttributes = "@attributes"
    private let kLegislator = "legislator"
    
    var fullName: String?
    var candidateId: String?
    
    init?(dictionary: [String: AnyObject])  {
        
        guard let attributesDictionary = dictionary[kAttributes] as? [String : AnyObject],
            cid = attributesDictionary[kID] as? String,
            fullName = attributesDictionary[kFullName] as? String else { return nil}
        
        self.candidateId = cid
        self.fullName = fullName
    }
}
