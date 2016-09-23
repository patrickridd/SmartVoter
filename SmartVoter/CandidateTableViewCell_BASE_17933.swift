//
//  CandidateTableViewCell.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/22/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class CandidateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButtons()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupButtons() {
        let phoneImage = UIImage(named: "Phone-50")
        let emailImage = UIImage(named: "New Message-48")
        let websiteImage = UIImage(named: "Safari-48")
        
        phoneButton.setImage(phoneImage, forState: .Normal)
        emailButton.setImage(emailImage, forState: .Normal)
        websiteButton.setImage(websiteImage, forState: .Normal)
    }
    
    func updateWith(candidate: Candidate) {
        
        nameLabel.text = candidate.name
        partyLabel.text = candidate.party
        phoneLabel.text = candidate.phone
        emailLabel.text = candidate.email
        websiteLabel.text = candidate.websiteURL
    }
}








