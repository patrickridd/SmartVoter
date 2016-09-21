//
//  ProfileViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SafariServices


class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var livingAddressLabel: UILabel!
    @IBOutlet weak var registerToVoteLabel: UIButton!
    @IBOutlet weak var placesToVoteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    
    
    var livingAddress: String?
    var pollingLocations: [CLLocation]?
    var registrationURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        populateMapView()
    }
    
    /// User to site where they can register to vote.
    @IBAction func registerToVoteButtonTapped(sender: AnyObject) {
        guard let urlString = self.registrationURL, let url = NSURL(string: urlString) else {
            return
        }
        let safariVC = SFSafariViewController(URL: url)
        self.presentViewController(safariVC, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        guard let newAddress = addressTextField.text where newAddress.characters.count > 0 else {
            return
        }
        
        ProfileController.sharedController.saveAddressToUserDefault(newAddress)
        updateLabels()
        
    }
    /// Updates VC's labels.
    func updateLabels() {
        self.livingAddress = ProfileController.sharedController.loadAddress()
        livingAddressLabel.text = livingAddress ?? "No Address Found"
        self.registrationURL = ProfileController.sharedController.loadURL()
        saveButtonLabel.layer.masksToBounds = true
        saveButtonLabel.layer.cornerRadius = 8.0
        
    }
    
    /// Gets User's Polling Locations as CLLocations and populates them on a map.
    func populateMapView() {
        PollingLocationController.sharedController.geoCodePollingAddresses { (pollingLocationCLLocation) in
            if pollingLocationCLLocation.count == 0 {
                self.placesToVoteLabel.text = "No Data found for your Polling Locations"
                return
            }
            
            let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            
            for (location, pollingLocation) in pollingLocationCLLocation {
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = pollingLocation.locationName
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
}
