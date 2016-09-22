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
    
    var address: Address?
    static let sharedController = ProfileController()
    
    
    func saveAddressToUserDefault(address: Address) {
        self.address = address
        let data = NSKeyedArchiver.archivedDataWithRootObject(address)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: addressKey)
    }
    func saveRegisterToVoteURL(url: String) {
        NSUserDefaults.standardUserDefaults().setObject(url, forKey: urlKey)
    }
    
    func loadAddress() ->Address? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(addressKey) as? NSData {
        let address = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Address
            self.address = address
            return address
        } else {
            return nil
        }
    }
    
    func loadURL() -> String? {
        let url = NSUserDefaults.standardUserDefaults().objectForKey(urlKey) as? String
        return url ?? nil
    }

    
    
}
