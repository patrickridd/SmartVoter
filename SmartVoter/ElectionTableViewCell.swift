//
//  ElectionTableViewCell.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class ElectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var electionDateLabel: UILabel!
    @IBOutlet weak var electionNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateWithElection(election: Contest) {
        if election.type == "General" {
            let office = election.office
            let type = election.type
            
            electionNameLabel.text = office
            electionDateLabel.text = type
        } else if election.type == "Referendum" {
            let title = election.referendumTitle
            let type = election.type
            
            electionNameLabel.text = title?.capitalizedString
            electionDateLabel.text = type.capitalizedString
        }
        
        if election.scope.lowercaseString.containsString("state") {
//            let image = UIImage(named: "\()")
        }
    }
}













