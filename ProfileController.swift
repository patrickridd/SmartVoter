//
//  ProfileController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class ProfileController {
    
    let urlKey = "urlKey"
    let addressKey = "addressKey"
    
    var address = [String]()
    
    static let sharedController = ProfileController()
    
    
    func saveAddressToUserDefault(address: String) {
        NSUserDefaults.standardUserDefaults().setObject(address, forKey: addressKey)
    }
    func saveRegisterToVoteURL(url: String) {
        NSUserDefaults.standardUserDefaults().setObject(url, forKey: urlKey)
    }
    func loadAddress() ->String? {
        let address = NSUserDefaults.standardUserDefaults().objectForKey(addressKey) as? String
        
        return address ?? nil
    }
    
    func loadURL() -> String? {
        let url = NSUserDefaults.standardUserDefaults().objectForKey(urlKey) as? String
        return url ?? nil
    }

    
    
}
