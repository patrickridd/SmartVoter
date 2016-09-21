//
//  OfficialDetailViewController.swift
//  SmartVoter
//
//  Created by Travis Sasselli on 9/21/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class OfficialDetailViewController: UIViewController {

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
        emailLabel.text = official.
        
    }
    

    @IBAction func webButtonTapped(sender: AnyObject) {
    }
    @IBAction func addressButtonTapped(sender: AnyObject) {
    }
    @IBAction func emailButtonTapped(sender: AnyObject) {
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
