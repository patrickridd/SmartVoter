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
    
    
    var official: Official?
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let official = official,
            address = address
            else {
                return
        }
        updateOfficials(official, address: address)
        
    }
    
    func updateOfficials(official: Official, address: Address) {
        
        officialName.text = official.name
        officialOfficeLabel.text = official.office
        webAddressLabel.text = official.url
        streetAddressLabel.text = address.asAString
        emailLabel.text = official.email
        guard let photoURL = official.photoURL else { return }
        ImageController.imageForURL(photoURL) { (image) in
            self.officialImageView.image = image
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
        guard let vc = storyboard?.instantiateViewControllerWithIdentifier("addressMapView") else {
            return
        }
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject) {
        guard MFMailComposeViewController.canSendMail()
            else { return }
        
        guard let officialEmail = official?.email else { return }
        
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        
        mailController.setToRecipients([officialEmail])
        print(officialEmail)
        
        presentViewController(mailController, animated: true , completion: nil)
        
    }
    
    @IBAction func phoneButtonTapped(sender: AnyObject) {
        
        if let official = official {
            
            let alertController = UIAlertController(title: "Would you like to representative \(official.name ?? "No Contact Found")", message: "Press Ok to call \(official.name).", preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
                
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
            
            let noAction = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
                print("cancelled Call")
            }
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func socialButtonTapped(sender: AnyObject) {
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addressMapView" {
            
            guard let detailViewController = segue.destinationViewController as? OfficialAddressMapViewController else { return }
            guard let address = address?.asAString else { return }
            detailViewController.address = address
        }
    }
}
