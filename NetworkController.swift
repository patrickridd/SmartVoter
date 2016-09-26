//
//  NetworkController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation
class NetworkController {
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
        
        
    }
    
    static func performRequestForURL(url: NSURL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, body: NSData? = nil, completion: ((data: NSData?, error: NSError?) ->Void)?) {
        var request: NSMutableURLRequest?
        if urlParameters != nil {
            let requestUrl = urlFromParameters(url, urlParameters: urlParameters)
            request = NSMutableURLRequest(URL: requestUrl)
        } else {
            request = NSMutableURLRequest(URL: url)
        }
        request?.HTTPMethod = httpMethod.rawValue
        request?.HTTPBody = body
        guard let newRequest = request else {
            if let completion = completion {
                completion(data: nil, error: nil)
            }
            return
        }
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(newRequest) { (data, response, error) in
            if let completion = completion {
                completion(data: data, error: error)
            }
        }
        dataTask.resume()
        
    }
    
    static func urlFromParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value: $0.1)})
        
        if let url = components?.URL {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}
