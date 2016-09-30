//
//  ReferendumDetailViewController.swift
//  SmartVoter
//
//  Created by Brad on 9/30/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import  SafariServices

class ReferendumDetailViewController: UIViewController {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var referendumTitleLabel: UILabel!
    @IBOutlet weak var electionDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var contest: Contest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Setup view
    
    func setupView() {
        guard let contest = contest, let state = ProfileController.sharedController.address?.state.capitalizedString else { return }
        
        flagImageView.image = UIImage(named: "\(state)-flag-large")
        referendumTitleLabel.text = contest.referendumTitle?.capitalizedString
        electionDateLabel.text = "Election Day: \(contest.electionDay)"
        descriptionLabel.text = contest.referendumSubtitle?.capitalizedString
    }
    
    // Actions
    
    @IBAction func toSafariButtonPressed(sender: AnyObject) {
        
        guard let state = ProfileController.sharedController.address?.state else { return }
        guard let escapedReferendumString = contest?.referendumTitle?.stringByReplacingOccurrencesOfString(" ", withString: "+") else { return }
        
        let referendum = "\(escapedReferendumString)+\(state)"
        
        if let url = NSURL(string: "http://www.google.com/search?q=\(referendum)") {
            let safariVC = SFSafariViewController(URL: url)
            if #available(iOS 10.0, *) {
                safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
            } else {
                UIApplication.sharedApplication().statusBarStyle = .Default
            }
            presentViewController(safariVC, animated: true, completion: nil)
        } else {
            print("Error")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}









