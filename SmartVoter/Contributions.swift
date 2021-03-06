//
//  Contributions.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/29/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class Contributions {
    
    private let kResponse = "response"
    private let kContributor =  "contributor"
    private let kContributors = "contributors"
    private let kAttributes = "@attributes"
    private let kFullName = "cand_name"
    private let kOrganization = "org_name"
    private let kTotal = "total"
   
    var organizations: [String]? = []
    var totals: [NSString]? = []
    
    init?(dictionary: [String: AnyObject])  {
        
        guard let response = dictionary[kResponse] as? [String : AnyObject],
        let contributors = response[kContributors] as? [String : AnyObject],
            let contributorArray = contributors[kContributor] as? [[String : AnyObject]] else { return nil }
        
        for contributor in contributorArray {
            guard let attributesDictionary = contributor[kAttributes] as? [String : AnyObject],
            let organization = attributesDictionary[kOrganization] as? String,
                let total = attributesDictionary[kTotal] as? NSString else { return nil }
            self.organizations?.append(organization)
            self.totals?.append(total)
        }
    }
}
