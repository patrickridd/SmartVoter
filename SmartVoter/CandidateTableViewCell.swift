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
    
    weak var delegate: CandidateTableViewCellDelegate?
    var candidate: Candidate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupButtonFor(candidate: Candidate) {
        
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
        
        if candidate.phone != nil {
            phoneLabel.text = candidate.phone
        } else {
            phoneLabel.hidden = true
        }
        if candidate.email != nil {
            emailLabel.text = candidate.email
        } else {
            emailLabel.hidden = true
        }
        if candidate.websiteURL != nil {
            websiteLabel.text = "Website"
//            websiteLabel.text = candidate.websiteURL
        } else {
            websiteLabel.hidden = true
        }
        
        setupButtonFor(candidate)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        phoneLabel.hidden = false
        emailLabel.hidden = false
        websiteLabel.hidden = false
        
        phoneButton.hidden = false
        emailButton.hidden = false
        websiteButton.hidden = false
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








