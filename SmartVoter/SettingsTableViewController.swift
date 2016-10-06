//
//  SettingsTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/27/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import EventKit


class SettingsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var whenYouWantToBeNotified: UILabel!
    @IBOutlet weak var updateLabel: UIButton!
    @IBOutlet weak var livingAddress: UILabel!
    @IBOutlet weak var doneButtonLabel: UIBarButtonItem!
    @IBOutlet weak var changeSettingsButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var segmentControlLabel: UISegmentedControl!
    
    let eventStore = EKEventStore()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        updateLivingAddressLabel()
        roundButtonCorners()
        setupTitleView()
        setupNotificationObservers()
        guard let address = ProfileController.sharedController.loadAddress() else { return }
        SettingsController.sharedController.getElectionDate(address) {
            self.setupNotificationLabelAndSegmentControl()
            self.checkCalendarAuthorizationStatus()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setupNotificationLabelAndSegmentControl()
    }
    
    /// Changes the view to show textfields and blurview so the user can update their address.
    @IBAction func updateAddressButtonTappedWithSender(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpVC = storyBoard.instantiateViewControllerWithIdentifier("SignUp")
        
        self.presentViewController(signUpVC, animated: true, completion: nil)
    }
    
    // Dismisses the SettingTableViewController
    
    @IBAction func doneButtonTappedWithSender(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    // Allows user to change notification setting by taking them to ios Settings.
    
    @IBAction func changeSettingsButtonTapped(sender: AnyObject) {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(appSettings)
        }
    }
    
    // Saves new address or returns to normal view if there is an incorrect input
    @IBAction func segmentControlTapped(sender: AnyObject) {
        scheduleNotifications()
    }
    
    func setupNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setupNotificationLabelAndSegmentControl), name: WillEnterForeground, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateLivingAddressLabel), name: ProfileViewController.addressChangedNotification, object: nil)
    }
    
    func scheduleNotifications() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            SettingsController.sharedController.scheduleDayOfNotification()
        case 1:
            SettingsController.sharedController.scheduleOneDayNotification()
        case 2:
            SettingsController.sharedController.scheduleOneWeekNotification()
        default:
            SettingsController.sharedController.scheduleNotficationForAllOptions()
        }
    }
    
    func setupNotificationLabelAndSegmentControl() {
        let notificationStatus = ProfileController.sharedController.checkIfNotificationsAreEnabled()
        
        if notificationStatus {
            statusLabel.textColor = UIColor.bradsBlue()
            statusLabel.text = "ON"
            segmentedControl.enabled = true
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            checkForPreviousSetting()
            scheduleNotifications()
        } else {
            statusLabel.textColor = UIColor.navigationRed()
            statusLabel.text = "OFF"
            //ProfileController.sharedController.loadNotificationStatus()
            segmentedControl.enabled = false
        }
    }
    
    func checkForPreviousSetting() {
        let setting = ProfileController.sharedController.loadNotificationSetting()
        switch setting {
        case "dayOf":
            segmentedControl.selectedSegmentIndex = 0
        case  "oneDay":
            segmentedControl.selectedSegmentIndex = 1
        case "oneWeek":
            segmentedControl.selectedSegmentIndex = 2
        case "all":
            segmentedControl.selectedSegmentIndex = 3
        default:
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            SettingsController.sharedController.createElectionEventInCalendar()
            break
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            break
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.checkCalendarAuthorizationStatus()
                })
            } else {
                return
            }
        })
    }
    
    func setupTitleView(){
        if let font = UIFont(name: "Avenir", size: 28) {
            let attributes =
                [NSForegroundColorAttributeName: UIColor.whiteColor(),
                 NSFontAttributeName: font]
            UINavigationBar.appearance().titleTextAttributes = attributes
        }
    }
    
    func roundButtonCorners() {
        updateLabel.layer.masksToBounds = true
        updateLabel.layer.cornerRadius = 8.0
        changeSettingsButton.layer.masksToBounds = true
        changeSettingsButton.layer.cornerRadius = 8.0
    }
    
    // Updates the label with a new address
    func updateLivingAddressLabel() {
        guard let address = ProfileController.sharedController.loadAddress() else {
            return
        }
        let allCapsAddress = address.asAString.uppercaseString
        self.livingAddress.text = allCapsAddress
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height-60
    }
    
    
}



