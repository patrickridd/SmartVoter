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
    
    
//    @IBOutlet weak var livingAddressLabel: UILabel!
    @IBOutlet weak var registerToVoteLabel: UIButton!
    @IBOutlet weak var placesToVoteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var updateLabel: UIBarButtonItem!
    
    static let addressChangedNotification = "Address Changed"
    var livingAddress: Address?
    var pollingLocations: [CLLocation]?
    var registrationURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        populateMapView()
    }
    
    
    @IBAction func updateButtonTapped(sender: AnyObject) {
        if updateLabel.title == "Update" {
            updateLabel.title = "Save"
            registerToVoteLabel.hidden = true
            streetTextField.hidden = false
            cityTextField.hidden = false
            stateTextField.hidden = false
            zipTextField.hidden = false
        } else {
            updateLabel.title = "Update"
    
            guard let stateText = stateTextField.text where stateText.characters.count > 0,
                let cityText = cityTextField.text where cityText.characters.count > 0,
                let streetText = streetTextField.text where streetText.characters.count > 0,
                let zipText = zipTextField.text where zipText.characters.count > 0  else {
                return
            }
            
            let newAddress = Address(line1: streetText, city: cityText, state: stateText, zip: zipText)
            ProfileController.sharedController.saveAddressToUserDefault(newAddress)
            updateLabels()

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(ProfileViewController.addressChangedNotification, object: self)
            })
        }
    }
    
    
    /// User to site where they can register to vote.
    @IBAction func registerToVoteButtonTapped(sender: AnyObject) {
        guard let urlString = self.registrationURL, let url = NSURL(string: urlString) else {
            return
        }
        let safariVC = SFSafariViewController(URL: url)
        self.presentViewController(safariVC, animated: true, completion: nil)
        
    }
    
        /// Updates VC's labels.
    func updateLabels() {
        registerToVoteLabel.hidden = false
        streetTextField.hidden = true
        cityTextField.hidden = true
        stateTextField.hidden = true
        zipTextField.hidden = true
        guard let livingAddress = ProfileController.sharedController.loadAddress() else {
            return
        }
        self.livingAddress = livingAddress
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica", size: 14)!]
        self.navigationItem.title = self.livingAddress?.line1 ?? "No Address Found"
        self.registrationURL = ProfileController.sharedController.loadURL()
       
        
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
