//
//  OfficialAddressMapViewController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/21/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import MapKit

class OfficialAddressMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var address: String?
    var locationManager: CLLocationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 3000
    var currertLocatoin: CLLocation?
    var coordinate: CLLocationCoordinate2D?
    var geocoder: CLGeocoder = CLGeocoder()
    var regionSet: Bool = false
    var region: MKCoordinateRegion?
    
    var official: Official?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        
    }
    
    func setupMapView () {
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLHeadingFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView?.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.scrollEnabled = true
        guard let newAddress = address else { return }
        forwardGeocodeAddress(newAddress) { (location) in
            let annotation = MKPointAnnotation()
            guard let coordinate = location?.coordinate else { return }
            annotation.coordinate = coordinate
            annotation.title = newAddress
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    func forwardGeocodeAddress (address: String, completion: (location: CLLocation?) -> Void) {
        let geoCoder = CLGeocoder()
        var location = CLLocation?()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemark = placemarks?.first {
                location = placemark.location
            } else {
                print("\(error!.localizedDescription)")
            }
            completion(location: location)
        }
        
    }
}
