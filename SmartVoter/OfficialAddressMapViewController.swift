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
    var coordinate: CLLocationCoordinate2D?
    var geocoder: CLGeocoder = CLGeocoder()
    var official: Official?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        
    }
    
    //MARK: Map View Functions/Setup
    
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
           guard let officialNames = self.official?.name else { return }
            annotation.coordinate = coordinate
            annotation.title = officialNames
            annotation.subtitle = newAddress
            self.mapView.addAnnotation(annotation)
            let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 8000, 8000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKindOfClass(MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "liberty.png")
        }
        
        return annotationView
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
