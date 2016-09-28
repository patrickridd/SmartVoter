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

private var kAssociationKeyNextField: UInt8 = 0


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var registerToVoteLabel: UIButton!
    @IBOutlet weak var placesToVoteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var electionWebsiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var safariButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    static let addressChangedNotification = "Address Changed"
    var livingAddress: Address?
    var pollingLocations: [CLLocation]?
    var registrationURL: String?
    
    let rightButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileViewController()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updatePollingLocation), name: ProfileViewController.addressChangedNotification, object: nil)

    }
    
    func setupProfileViewController() {
        let logo = UIImage(named: "Logo Large")
        let logoImageView = UIImageView(image: logo)
        self.navigationItem.titleView = logoImageView
        self.updateLabels()
        registerToVoteLabel.layer.masksToBounds = true
        registerToVoteLabel.layer.cornerRadius = 8.0
        setRightButton()
        guard let address = ProfileController.sharedController.loadAddress() else {
            return
        }
        ProfileController.getPollingAddress(address) {
            self.populateMapView()
        }
    }
    
    
    @IBAction func safariButtonTappedWithSender(sender: AnyObject) {
        guard let websiteString = ProfileController.electionWebsite, let url = NSURL(string: websiteString ) else {
            electionWebsiteLabel.text = "Website: No website found"
            safariButton.enabled = false
            safariButton.hidden = true
            return
        }
        let safariVC = SFSafariViewController(URL: url)
        if #available(iOS 10.0, *) {
            safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
        } else {
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(safariVC, animated: true, completion: nil)
        })
    }
    
    @IBAction func phoneNumberButtonTappedWithSender(sender: AnyObject) {
        guard let phoneNumber = ProfileController.electionPhoneNumber else {
            phoneNumberLabel.text = "Phone Number: No number found"
            phoneNumberButton.hidden = true
            phoneNumberButton.enabled = false
            return
        }
        let formattedNumber = ProfileController.sharedController.formatNumberForCall(phoneNumber)
        guard let callURL = NSURL(string: "tel://\(formattedNumber)") else {
            phoneNumberLabel.text = "Phone Number:" + " No number found"
            phoneNumberButton.hidden = true
            phoneNumberButton.enabled = false
            return
        }
        let alert = UIAlertController(title: "Do you want to Call Elections Office", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let callAction = UIAlertAction(title: "Call", style: .Default) { (_) in
            UIApplication.sharedApplication().openURL(callURL)
        }
        alert.addAction(cancelAction)
        alert.addAction(callAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    
    /// Takes user to website where they can register to vote.
    @IBAction func registerToVoteButtonTappedWithSender(sender: AnyObject) {
        guard let urlString = self.registrationURL, let url = NSURL(string: urlString) else {
            return
        }
        let safariVC = SFSafariViewController(URL: url)
        if #available(iOS 10.0, *) {
            safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
        } else {
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(safariVC, animated: true, completion: nil)
        })
    }
    
    
    func setRightButton() {
        let image = UIImage(named: "Settings-100")?.imageWithRenderingMode(.AlwaysTemplate)
        rightButton.tintColor = UIColor.whiteColor()
        rightButton.setImage(image, forState: .Normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightButton.contentMode = .ScaleAspectFit
        rightButton.addTarget(self, action: #selector(presentSettingsTableViewController), forControlEvents: UIControlEvents.TouchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func presentSettingsTableViewController() {
        let storyBoard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsTVC = storyBoard.instantiateViewControllerWithIdentifier("SettingNavigationController")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(settingsTVC, animated: true, completion: nil)
        })
    }
    
    
    func updatePollingLocation() {
        let allAnnotations = self.mapView.annotations

        self.mapView.removeAnnotations(allAnnotations)
        guard let address = ProfileController.sharedController.loadAddress() else {
            return
        }
        ProfileController.getPollingAddress(address) {
            self.populateMapView()
        }
    }
    
    /// Updates VC's labels.
    func updateLabels() {
        phoneNumberLabel.hidden = false
        phoneNumberButton.hidden = false
        phoneNumberButton.enabled = true
        electionWebsiteLabel.hidden = false
        safariButton.hidden = false
        safariButton.enabled = true
        registerToVoteLabel.hidden = false
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
                
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.showsUserLocation = true
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
}
