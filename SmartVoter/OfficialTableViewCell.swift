//
//  OfficialTableViewCell.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class OfficialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var officialsImageView: UIImageView!
    @IBOutlet weak var officialsNameLabel: UILabel!
    @IBOutlet weak var officialsOfficeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateOfficialsCell(office: Office, official: Official) {
        officialsNameLabel.text = official.name
        officialsOfficeLabel.text = office.name
        
        ImageController.imageForURL(official.photoURL ?? "") { (image) in
            guard let image = image else {return}
            self.officialsImageView.image = image
        }
        
    }

}
