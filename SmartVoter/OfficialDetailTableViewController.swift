//
//  OfficialDetailTableViewController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/26/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
import MessageUI

class OfficialDetailTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var officialImageView: UIImageView!
    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var officialOfficeLabel: UILabel!
    @IBOutlet weak var webAddressLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var googlePlusButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    var official: Official?
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let official = official else { return }
        
        updateOfficials(official)
        upDateBackgroundColor()
        updateSocialButtons()
        hideTextField()
        
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source
    
    func updateOfficials(official: Official) {
        let address = official.address
        self.address = address
        officialName.text = official.name
        phoneNumberLabel.text = "Office Phone"
        officialOfficeLabel.text = official.office?.name
        webAddressLabel.text = "Website"
        streetAddressLabel.text = "Office Address"
        emailLabel.text = "E-mail"
        socialMediaLabel.text = "Social Media"
        if official.party != nil {
            guard let party = official.party else { return }
            partyLabel.text = "\(party) Party"
        } else {
            partyLabel.text = "Party affiliation information is unavailable"
        }
        if let photoURL = official.photoURL {
            if let photo = official.image {
                self.officialImageView.image = photo
            } else {
                ImageController.imageForURL(photoURL) { (image) in
                    if image != nil {
                        self.officialImageView.image = image
                    } else {
                        guard let state = ProfileController.sharedController.address?.state.capitalizedString else { return }
                        self.officialImageView.image = UIImage(named: "\(state)-flag-large")
                    }
                }
            }
        } else {
            guard let state = ProfileController.sharedController.address?.state.capitalizedString else { return }
            self.officialImageView.image = UIImage(named: "\(state)-flag-large")
        }
    }
    
    @IBAction func webButtonTapped(sender: AnyObject) {
        guard let official = official else { return }
        guard let officialWebsite = official.url else { return }
        guard let urls = NSURL(string: officialWebsite) else { return }
        
        let safariVC = SFSafariViewController(URL: urls)
        if #available(iOS 10.0, *) {
            safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
        } else {
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
        
        presentViewController(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func addressButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    @IBAction func phoneButtonTapped(sender: AnyObject) {
        if let official = official {
            
            let alertController = UIAlertController(title: "Would you like to call the office of \(official.name ?? "No Contact Found")?", message: "Press the Call button to make a call.", preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: "Call", style: .Default) { (action) -> Void in
                
                guard let officialPhoneNumber = official.phone else { return }
                var phoneNumberNoCharacter = officialPhoneNumber
                phoneNumberNoCharacter = phoneNumberNoCharacter.stringByReplacingOccurrencesOfString(
                    "\\D", withString: "", options: .RegularExpressionSearch,
                    range: phoneNumberNoCharacter.startIndex..<phoneNumberNoCharacter.endIndex)
                // print(officialPhoneNumber)
                if let phoneCallURL:NSURL = NSURL(string: "tel:\(phoneNumberNoCharacter ?? "No Number Found")") {
                    let application:UIApplication = UIApplication.sharedApplication()
                    if (application.canOpenURL(phoneCallURL)) {
                        application.openURL(phoneCallURL);
                        //   print (officialPhoneNumber)
                    }
                }
            }
            
            let noAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                
            }
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookButtonTapped(sender: AnyObject) {
        guard let socialArray = official?.social else { return }
        for social in socialArray {
            if social.type == "Facebook" {
                
                guard let id = social.id else { return }
                
                if (id.lowercaseString.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil) {
                    
                    guard let id = social.id else { return }
                    let facebookURL = "https://www.facebook.com/\(id)"
                    guard let urls = NSURL(string: facebookURL) else { return }
                    
                    let safariVC = SFSafariViewController(URL: urls)
                    if #available(iOS 10.0, *) {
                        safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
                    } else {
                        UIApplication.sharedApplication().statusBarStyle = .Default
                    }
                    
                    presentViewController(safariVC, animated: true, completion: nil)
                }
                    
                else {
                    guard let url = NSURL(string: "fb://profile/\(id)") else { return }
                    let facebookURL = url
                    if UIApplication.sharedApplication().canOpenURL(facebookURL) {
                        UIApplication.sharedApplication().openURL(facebookURL)
                    } else {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/\(id)")!)
                    }
                }
            }
        }
    }
    
    @IBAction func googlePlusButtonTapped(sender: AnyObject) {
        guard let socialArray = official?.social else { return }
        for social in socialArray {
            guard let id = social.id else { return }
            if social.type == "GooglePlus"  {
                guard let googlePlusURL = NSURL(string: "gplus://plus.google.com/u/0/\(id)") else { return }
                if UIApplication.sharedApplication().canOpenURL(googlePlusURL) {
                    UIApplication.sharedApplication().openURL(googlePlusURL)
                } else {
                    let googlePlusURL = "https://plus.google.com/\(id)"
                    guard let urls = NSURL(string: googlePlusURL) else { return }
                    let safariVC = SFSafariViewController(URL: urls)
                    if #available(iOS 10.0, *) {
                        safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
                    } else {
                        UIApplication.sharedApplication().statusBarStyle = .Default
                    }
                    presentViewController(safariVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func youTubeButtonTapped(sender: AnyObject) {
        guard let socialArray = official?.social else { return }
        for social in socialArray {
            guard let youtubeId = social.id else { return }
            if social.type == "YouTube" {
                guard let url = NSURL(string:"youtube://user/\(youtubeId)") else { return }
                if UIApplication.sharedApplication().canOpenURL(url)  {
                    UIApplication.sharedApplication().openURL(url)
                } else {
                    let twitterURL = "https://www.youtube.com/user/\(youtubeId)"
                    guard let urls = NSURL(string: twitterURL) else { return }
                    
                    let safariVC = SFSafariViewController(URL: urls)
                    if #available(iOS 10.0, *) {
                        safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
                    } else {
                        UIApplication.sharedApplication().statusBarStyle = .Default
                    }
                    
                    presentViewController(safariVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func twittlerButtonTapped(sender: AnyObject) {
        guard let socialArray = official?.social else { return }
        for social in socialArray {
            guard let id = social.id else { return }
            if social.type == "Twitter" {
                guard let twitterURL = NSURL(string: "twitter://user?screen_name=\(id)") else { return }
                if UIApplication.sharedApplication().canOpenURL(twitterURL) {
                    UIApplication.sharedApplication().openURL(twitterURL)
                    print(twitterURL)
                } else {
                    let twitterURL = "https://www.twitter.com/\(id)"
                    guard let urls = NSURL(string: twitterURL) else { return }
                    let safariVC = SFSafariViewController(URL: urls)
                    if #available(iOS 10.0, *) {
                        safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
                    } else {
                        UIApplication.sharedApplication().statusBarStyle = .Default
                    }
                    presentViewController(safariVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: Email helper functions
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        guard let officialEmail = self.official?.email else { return MFMailComposeViewController()}
        mailComposerVC.setToRecipients([officialEmail])
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        _ = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration in settings and try again.", preferredStyle: .Alert)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //  MARK: Helper Functions
    
    func schemeAvailable(scheme: String) -> Bool {
        if let url = NSURL(string: scheme) {
            return UIApplication.sharedApplication().canOpenURL(url)
        }
        return false
    }
    
    func upDateBackgroundColor () {
        backgroundImage.image = backgroundImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        if official?.party == "Democratic" {
            backgroundImage.backgroundColor = UIColor.bradsBlue()
        } else if official?.party == "Republican" {
            backgroundImage.backgroundColor = UIColor.navigationRed()
        }
    }
    
    func updateSocialButtons() {
        
        socialMediaLabel.hidden = true
        facebookButton.hidden = true
        twitterButton.hidden = true
        googlePlusButton.hidden = true
        youtubeButton.hidden = true
        
        guard let official = official else { return }
        
        for social in (official.social) {
            if social.type == "YouTube" {
                socialMediaLabel.hidden = false
                youtubeButton.hidden = false
            }
            if social.type == "Twitter" {
                socialMediaLabel.hidden = false
                twitterButton.hidden = false
            }
            if social.type == "GooglePlus" {
                socialMediaLabel.hidden = false
                googlePlusButton.hidden = false
            }
            if social.type == "Facebook" {
                socialMediaLabel.hidden = false
                facebookButton.hidden = false
            }
        }
    }
    
    func hideTextField() {
        
        guard let official = official else { return }
        
        if official.phone != nil {
            phoneNumberLabel.hidden = false
        } else {
            phoneNumberLabel.hidden = true
            phoneButton.hidden = true
        }
        if official.email != nil {
            emailLabel.hidden = false
            emailButton.hidden = false
        } else {
            emailLabel.hidden = true
            emailButton.hidden = true
        }
        if official.address != nil {
            streetAddressLabel.hidden = false
        } else {
            streetAddressLabel.hidden = true
            mapButton.hidden = true
        }
        if official.url == nil {
            webAddressLabel.hidden = true
            websiteButton.hidden = true
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addressMapView" {
            
            guard let detailViewController = segue.destinationViewController as? OfficialAddressMapViewController else { return }
            guard let address = address else { return }
            detailViewController.address = address.asAString
            detailViewController.official = official
        }
        
                if segue.identifier == "barViewSegue" {
                    guard let detailVC = segue.destinationViewController as?  BarChartViewController else { return }
                    detailVC.official = official
                }
    }
}
