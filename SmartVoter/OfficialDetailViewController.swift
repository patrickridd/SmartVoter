//
//  OfficialDetailViewController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/21/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class OfficialDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var officialImageView: UIImageView!
    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var officialOfficeLabel: UILabel!
    @IBOutlet weak var webAddressLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var socialMediaButton: UIButton!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    var official: Official?
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let official = official
            else {
                return
        }
        updateOfficials(official)
        updateSocialButtonImage()
        upDateBackgroundColor()
        
     //   officialImageView.layer.cornerRadius = 9
     //   officialImageView.layer.masksToBounds = true
    }
    
    func updateOfficials(official: Official) {
        
        let address = official.address
        self.address = address
        officialName.text = official.name
        phoneNumberLabel.text = official.phone ?? "No phone number was provided"
        officialOfficeLabel.text = official.office?.name
        webAddressLabel.text = official.url ?? "No website found"
        streetAddressLabel.text = address?.asAString ?? "No address provided"
        emailLabel.text = official.email ?? "No email provided"
        socialMediaLabel.text = official.social?.type ?? "NO link provided"
        partyLabel.text = "\(official.party ?? "Representative did not provide party affiliation") Party"
        guard let photoURL = official.photoURL else { return }
        ImageController.imageForURL(photoURL) { (image) in
            self.officialImageView.image = image
        }
    }
    
    
    func upDateBackgroundColor () {
        
        backgroundImage.image = backgroundImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        if official?.party == "Democratic" {
        backgroundImage.backgroundColor = UIColor.bradsBlue()
        } else if official?.party == "Republican" {
        
        backgroundImage.backgroundColor = UIColor.navigationRed()
        }
    }
    
    func updateSocialButtonImage () {
        
        if official?.social?.type == "Facebook" {
            socialMediaButton.setImage(UIImage(named:"facebook.png"), forState: .Normal)
        } else if official?.social?.type == "GooglePlus" {
            socialMediaButton.setImage(UIImage(named:"googlePlus.png"), forState: .Normal)
        } else if official?.social?.type == "Twitter" {
            socialMediaButton.setImage(UIImage(named: "twitter.png"), forState: .Normal)
        } else if official?.social?.type == "YouTube" {
            socialMediaButton.setImage(UIImage(named: "youTube.png"), forState: .Normal)
        }
    }
    
    @IBAction func webButtonTapped(sender: AnyObject) {
        guard let official = official else { return }
        guard let officialWebsite = official.url else { return }
        guard let urls = NSURL(string: officialWebsite) else { return }
        
        let safariVC = SFSafariViewController(URL: urls)
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
            
            let alertController = UIAlertController(title: "Would you like to call \(official.name ?? "No Contact Found")", message: "Press the call button to call \(official.name ?? "No Contact Name Found").", preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: "Call", style: .Default) { (action) -> Void in
                
                guard let officialPhoneNumber = official.phone else { return }
                var phoneNumberNoCharacter = officialPhoneNumber
                phoneNumberNoCharacter = phoneNumberNoCharacter.stringByReplacingOccurrencesOfString(
                    "\\D", withString: "", options: .RegularExpressionSearch,
                    range: phoneNumberNoCharacter.startIndex..<phoneNumberNoCharacter.endIndex)
                print(officialPhoneNumber)
                if let phoneCallURL:NSURL = NSURL(string: "tel:\(officialPhoneNumber ?? "No Number Found")") {
                    let application:UIApplication = UIApplication.sharedApplication()
                    if (application.canOpenURL(phoneCallURL)) {
                        application.openURL(phoneCallURL);
                        print (officialPhoneNumber)
                    }
                }
            }
            
            let noAction = UIAlertAction(title: "Cancel Call", style: .Cancel) { (action) -> Void in
                print("cancelled Call")
            }
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func socialButtonTapped(sender: AnyObject) {
        
        if official?.social?.type == "Facebook" {
            guard let id = official?.social?.id else { return }
            let facebookURL = "https://www.facebook.com/\(id)"
            guard let urls = NSURL(string: facebookURL) else { return }
            
            let safariVC = SFSafariViewController(URL: urls)
            presentViewController(safariVC, animated: true, completion: nil)
        } else if official?.social?.type == "GooglePlus"  {
            guard let id = official?.social?.id else { return }
            let googlePlusURL = "https://plus.google.com/\(id)"
            guard let urls = NSURL(string: googlePlusURL) else { return }
            
            let safariVC = SFSafariViewController(URL: urls)
            presentViewController(safariVC, animated: true, completion: nil)
        } else if official?.social?.type == "Twitter" {
            guard let id = official?.social?.id else { return }
            let twitterURL = "https://www.twitter.com/\(id)"
            guard let urls = NSURL(string: twitterURL) else { return }
            
            let safariVC = SFSafariViewController(URL: urls)
            presentViewController(safariVC, animated: true, completion: nil)
        } else if official?.social?.type == "YouTube" {
            guard let id = official?.social?.id else { return }
            let twitterURL = "https://www.youtube.com/user/\(id)"
            guard let urls = NSURL(string: twitterURL) else { return }
            
            let safariVC = SFSafariViewController(URL: urls)
            presentViewController(safariVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Email helper functions
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        guard let officialEmail = self.official?.email else { return MFMailComposeViewController()}
        mailComposerVC.setToRecipients([officialEmail])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        _ = UIAlertController(title:"Could Not Send Email" , message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addressMapView" {
            
            guard let detailViewController = segue.destinationViewController as? OfficialAddressMapViewController else { return }
            guard let address = address else { return }
            detailViewController.address = address.asAString
            detailViewController.official = official
        }
    }
}
