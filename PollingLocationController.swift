//
//  PollingLocationController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/20/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PollingLocationController {
    
    static let sharedController = PollingLocationController()
    var pollingLocations = [PollingLocation]()
    
    
    /// Takes Polling Addresses and completion closure returns an array of Polling CLLocations
    func geoCodePollingAddresses(completion: (pollingLocationCLLocation: [(location: CLLocation, pollingLocation: PollingLocation)])->Void) {
        let geocoder = CLGeocoder()
        var locations = [(location:CLLocation, pollingLocation: PollingLocation)]()
        for pollingLocation in pollingLocations {
            let formattedAddress = formatPollingAdress(pollingLocation)
            geocoder.geocodeAddressString(formattedAddress) { (placemark, error) in
                
                guard let placemark = placemark?.first,
                    let location = placemark.location else {
                        return
                }
                locations.append(location: location, pollingLocation: pollingLocation)
                completion(pollingLocationCLLocation: locations)

            }
        }
    }
    
    /// This method formats the pollingLocations address properties into a single address and returns it as a String.
    func formatPollingAdress(pollingLocation: PollingLocation) -> String {
    
        let address = "\(pollingLocation.streetName), \(pollingLocation.zip), \(pollingLocation.city), \(pollingLocation.state)"
        
        return address
    }
    
    
    
}
