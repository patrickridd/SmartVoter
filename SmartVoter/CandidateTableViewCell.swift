//
//  CandidateTableViewCell.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/22/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class CandidateTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    let phoneImage = UIImage(named: "Phone-50")
    let emailImage = UIImage(named: "New Message-48")
    let websiteImage = UIImage(named: "Safari-48")
    
    weak var delegate: CandidateTableViewCellDelegate?
    var candidate: Candidate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupButtonFor(candidate: Candidate) {
        phoneButton.setImage(phoneImage, forState: .Normal)
        emailButton.setImage(emailImage, forState: .Normal)
        websiteButton.setImage(websiteImage, forState: .Normal)
        
        if candidate.phone == nil {
            phoneButton.hidden = true
        }
        if candidate.email == nil {
            emailButton.hidden = true
        }
        if candidate.websiteURL == nil {
            websiteButton.hidden = true
        }
    }
    
    func updateWith(candidate: Candidate) {
        
        self.candidate = candidate
        
        nameLabel.text = candidate.name
        partyLabel.text = candidate.party
        phoneLabel.text = candidate.phone
        emailLabel.text = candidate.email
        websiteLabel.text = candidate.websiteURL
    }
    
    // MARK: - Actions
    
    @IBAction private func phoneButtonTappedWithSender(sender: AnyObject) {
        guard let candidate = candidate else { return }
        delegate?.makePhoneCall(candidate)
    }
    
    @IBAction func emailButtonTappedWithSender(sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            guard let candidate = candidate else { return }
            delegate?.presentMailComposeVC(candidate)
        } else {
            delegate?.showSendMailErrorAlert()
        }
        print("I got tapped")
    }
    
    @IBAction func websiteButtonTappedWithSender(sender: AnyObject) {
        guard let candidate = candidate else { return }
        delegate?.presentWebViewFor(candidate)
    }
}

protocol CandidateTableViewCellDelegate: class {
    func presentMailComposeVC(candidate: Candidate)
    func showSendMailErrorAlert()
    func makePhoneCall(candidate: Candidate)
    func presentWebViewFor(candidate: Candidate)
}








