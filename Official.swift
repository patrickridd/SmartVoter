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
    var office: Office?
    var email: String?
    
    init?(dictionary: [String: AnyObject], office: Office)  {
        
        // Only Return nil if we can't get Official's name.
        guard let name = dictionary[kName] as? String else {
                return nil
        }
        
        self.name = name
        self.office = office
        
        // Get Party
        if let party = dictionary[kParty] as? String {
            self.party = party
        }
        
        // Get Address
        if let  addressArray = dictionary[kAddress] as? [[String: AnyObject]],
            addressDictionary = addressArray.first,
            let line1 = addressDictionary[kAddressLine1] as? String,
            let city = addressDictionary[kAddressCity] as? String,
            let state = addressDictionary[kAddressState] as? String,
            let zip = addressDictionary[kAddressZip] as? String {
            let address = Address(line1: line1, city: city, state: state, zip: zip)
            self.address = address
        }

        // Get Phone Number
        if let phoneArray = dictionary[kPhone] as? [String],
            phoneNumber = phoneArray.first {
            self.phone = phoneNumber
        }
        
        // Get Official's website if available
        if let urlArray = dictionary[kUrl] as? [String],
            url = urlArray.first  {
            self.url = url
        }
        
        // Get photo if available
        if let photoURL = dictionary[kPhoto] as? String {
            self.photoURL = photoURL
        }
        
        // Get email
        if let emailArray = dictionary[kEmail] as? [String],
            email = emailArray.first {
            self.email = email
        }
        // Get Social media items
        if let socialArray = dictionary[kSocial] as? [[String: AnyObject]]{
           for socialDictionary in socialArray {
            type = socialDictionary[kType] as? String
            id = socialDictionary[kId] as? String
            let social = Social(type: type, id: id)
            self.social = social
          //  print(social.type)
        }
    }
    }
}
