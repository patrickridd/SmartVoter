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
    private let kPhone = "phones"
    private let kParty = "party"
    private let kPhoto = "photoUrl"
    private let kUrl = "urls"
    private let kSocial = "channels"
    private let kType = "type"
    private let kId = "id"
    private let kEmail = "emails"
    
    var name: String?
    var address: Address?
    var party: String?
    var phone: String?
    var photoURL: String?
    var type: String?
    var id: String?
    var url: String?
    var social: Social?
    var office: String?
    var email: String? 
    
    init?(dictionary: [String: AnyObject], office: String)  {
        
        guard let name = dictionary[kName] as? String,
            party = dictionary[kParty] as? String,
            photoURL = dictionary[kPhoto] as? String else { return nil }
        self.name = name
        self.party = party
        self.photoURL = photoURL
        self.office = office
        
        guard let  addressArray = dictionary[kAddress] as? [[String: AnyObject]],
            addressDictionary = addressArray.first,
            let line1 = addressDictionary[kAddressLine1] as? String,
            let city = addressDictionary[kAddressCity] as? String,
            let state = addressDictionary[kAddressState] as? String,
            let zip = addressDictionary[kAddressZip] as? String
            else { return nil }
        
        let address = Address(line1: line1, city: city, state: state, zip: zip)
        self.address = address
        
        guard let phoneArray = dictionary[kPhone] as? [String],
            phoneNumber = phoneArray.first,
            urlArray = dictionary[kUrl] as? [String],
            url = urlArray.first else { return nil }
        self.phone = phoneNumber
        self.url = url
        		
        
        
        guard let socialArray = dictionary[kSocial] as? [[String: AnyObject]],
            socialDictionary = socialArray.first,
            let type = socialDictionary[kType] as? String,
            let id = socialDictionary[kId] as? String
            else { return nil }
        let social = Social(type: type, id: id)
        self.social = social
        
        guard let emailArray = dictionary[kEmail] as? [String],
            email = emailArray.first 
        
    }
    
}