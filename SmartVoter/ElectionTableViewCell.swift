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

    func updateWithElection() {
        let name = ElectionController.electionName
        let date = ElectionController.electionDate
        
        electionNameLabel.text = name
        electionDateLabel.text = date
    }
}
