//
//  ContributorController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/29/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation

class ContributorController {
    
    static let sharedController = ContributorController()
    static let apiKey = "37ae7a868a4d18f7a8bb41383e006cb1"
    static let baseURL = "http://www.opensecrets.org/api/"
    
    init() {
        fetchContributors("N00007360") { (contributions) in
            //
        }
    }
    
    func fetchContributors (id: String, completion: (contributions: Contributions?) -> Void) {
        let url = NSURL(string: ContributorController.baseURL)
        let urlParamaters = ["method" : "candContrib", "cid" : id, "apikey" : ContributorController.apiKey, "output" : "json"]
        
        guard let unwrappedURL = url else {
            print("Failed to get baseURL")
            return
        }
        NetworkController.performRequestForURL(unwrappedURL, httpMethod: .Get, urlParameters: urlParamaters, header: nil, body: nil) { (data, error) in
            guard let  data = data else {
                print("Error No data returned")
                return
            }
            guard let  jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String : AnyObject] else {
                print("Error serialization failed \(error?.localizedDescription)")
                completion(contributions: nil)
                return
            }
            
            let contributions = Contributions(dictionary: jsonDictionary)
            completion(contributions: contributions)
        }
    }
}






