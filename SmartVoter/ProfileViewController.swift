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


class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    
//    @IBOutlet weak var livingAddressLabel: UILabel!
    @IBOutlet weak var registerToVoteLabel: UIButton!
    @IBOutlet weak var placesToVoteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var updateLabel: UIBarButtonItem!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backgroundBlurImage: UIImageView!
    
    static let addressChangedNotification = "Address Changed"
    var livingAddress: Address?
    var pollingLocations: [CLLocation]?
    var registrationURL: String?
    var pollingAnnotations = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupProfileViewController()
    }
    
    func setupProfileViewController() {
        self.updateLabels()

        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        streetTextField.delegate = self
        
        guard let address = self.livingAddress else {
            return
        }
        print(address.asAString)
        ProfileController.getPollingAddress(address) { 
            self.populateMapView()
        }
    }
    
    @IBAction func updateButtonTapped(sender: AnyObject) {
        if updateLabel.title == "Update" {
            backgroundBlurImage.hidden = false
            updateLabel.title = "Save"
            blurView.hidden = false
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
                    self.updateLabels()
                return
            }
            
            let newAddress = Address(line1: streetText, city: cityText, state: stateText, zip: zipText)
            ProfileController.sharedController.saveAddressToUserDefault(newAddress)
            livingAddress = newAddress
            mapView.removeAnnotations(self.pollingAnnotations)
            self.pollingAnnotations.removeAll()
            setupProfileViewController()
            updateLabels()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(ProfileViewController.addressChangedNotification, object: self)
            })
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Takes user to website where they can register to vote.
    @IBAction func registerToVoteButtonTapped(sender: AnyObject) {
        guard let urlString = self.registrationURL, let url = NSURL(string: urlString) else {
            return
        }
        let safariVC = SFSafariViewController(URL: url)
        self.presentViewController(safariVC, animated: true, completion: nil)
        
    }
    
        /// Updates VC's labels.
    func updateLabels() {
        backgroundBlurImage.hidden = true
        blurView.hidden = true
        registerToVoteLabel.hidden = false
        streetTextField.hidden = true
        cityTextField.hidden = true
        stateTextField.hidden = true
        zipTextField.hidden = true
        guard let livingAddress = ProfileController.sharedController.loadAddress() else {
            return
        }
        self.livingAddress = livingAddress
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
            self.placesToVoteLabel.text = "Your Polling Locations"

            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            
            for (location, pollingLocation) in pollingLocationCLLocation {
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                if let pollingHours = pollingLocation.pollingHours {
                    annotation.subtitle = "\(pollingLocation.streetName) - Open \(pollingHours)"
                } else {
                    annotation.subtitle = pollingLocation.streetName
                }
                annotation.title = pollingLocation.locationName
                self.pollingAnnotations.append(annotation)
        
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.showsUserLocation = true
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
}
