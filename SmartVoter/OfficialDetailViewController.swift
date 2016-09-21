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
        guard MFMailComposeViewController.canSendMail()
            else {
            return
        }
        guard let officialEmail = official?.email else { return }
        
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        
        mailController.setToRecipients([officialEmail])
        print(officialEmail)
        
    presentViewController(mailController, animated: true , completion: nil)
    
    }
    @IBAction func phoneButtonTapped(sender: AnyObject) {
    }
    @IBAction func socialButtonTapped(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
