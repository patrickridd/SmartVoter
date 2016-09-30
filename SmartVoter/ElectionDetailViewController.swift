//
//  ElectionDetailViewController.swift
//  SmartVoter
//
//  Created by Brad on 9/21/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class ElectionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, CandidateTableViewCellDelegate {
    
    @IBOutlet weak var electionTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webToolbar: UIToolbar!
    
    var contest: Contest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupView() {
        guard let contest = contest else { return }
        
        dateLabel.text = "Election Day: \(contest.electionDay)"
        if contest.type == "General" {
            electionTypeLabel.text = contest.office
            descriptionLabel.text = contest.scope.capitalizedString
            webView.hidden = true
            webToolbar.hidden = true
        } else if contest.type == "Referendum" {
            electionTypeLabel.text = contest.referendumTitle?.capitalizedString
            descriptionLabel.text = contest.referendumSubtitle?.capitalizedString
            tableView.hidden = true
            webView.hidden = false
            webToolbar.hidden = false 
            setupWebView()
        }
        
        guard let state = ProfileController.sharedController.address?.state.capitalizedString else { return }
        iconImageView.image = UIImage(named: "\(state)-Flag-256")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contest = contest, candidates = contest.candidates else { return 0 }
        return candidates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("candidateCell") as? CandidateTableViewCell, contest = contest, candidates = contest.candidates else { return UITableViewCell() }
        
        let candidate = candidates[indexPath.row]
        cell.delegate = self
        cell.updateWith(candidate)
        //        cell.setupButtonFor(candidate)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Candidates"
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        headerView.textLabel?.textColor = UIColor.whiteColor()
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 19.0)
        headerView.contentView.backgroundColor = UIColor(red:0.10, green:0.36, blue:0.56, alpha:1.00)
        headerView.textLabel?.textAlignment = .Center
    }
    
    // MARK: - CandidateTableViewCellDelegate
    
    func presentMailComposeVC(candidate: Candidate) {
        
        guard let officialEmail = candidate.email else { return }
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([officialEmail])
        
        self.presentViewController(mailComposerVC, animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title:"Could Not Send Email" , message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func makePhoneCall(candidate: Candidate) {
        
        let alertController = UIAlertController(title: "Would you like to call the office of \(candidate.name ?? "No Contact Found")?", message: "Press the Call button to make a call.", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Call", style: .Default) { (action) -> Void in
            
            guard let officialPhoneNumber = candidate.phone else { return }
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
        
        let noAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in

        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentWebViewFor(candidate: Candidate) {
        
        guard let officialWebsite = candidate.websiteURL, url = NSURL(string: officialWebsite) else { return }
        
        let safariVC = SFSafariViewController(URL: url)
        if #available(iOS 10.0, *) {
            safariVC.preferredBarTintColor = UIColor(red: 0.780, green: 0.298, blue: 0.298, alpha: 1.00)
        } else {
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
        presentViewController(safariVC, animated: true, completion: nil)
    }
    
    func setupWebView() {
        
        guard let state = ProfileController.sharedController.address?.state else { return }
       // guard let ref = contest?.referendumTitle else { return }
        guard let escapedReferendumString = contest?.referendumTitle?.stringByReplacingOccurrencesOfString(" ", withString: "+") else { return }
        print(escapedReferendumString)
        let referendum = "\(escapedReferendumString)+\(state)"
        let webID = "http://www.google.com/search?q=\(referendum)"
        print(referendum)
        print(webID)
        if let url = NSURL(string: "http://www.google.com/search?q=\(referendum)") {
            webView.loadRequest(NSURLRequest(URL: url))
        } else {
            print("Error")
        }
    }
    
}








