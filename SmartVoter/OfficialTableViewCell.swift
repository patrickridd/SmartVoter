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
    
    var official: Official?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func updateOfficialsCell(official: Official) {
        if official.party == "Democratic" {
        officialsNameLabel.text = "\(official.name ?? "No name found") (D)"
        
        } else if official.party == "Republican" {
            officialsNameLabel.text = "\(official.name ?? "No name found") (R)"
        }
            else if official.party == "Libertarian" {
            officialsNameLabel.text = "\(official.name ?? "No name found") (L)"
        } else {
            officialsNameLabel.text = official.name
        }
        officialsOfficeLabel.text = official.office?.name
        if let image = official.image {
            self.officialsImageView.image = image
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ImageController.imageForURL(official.photoURL ?? "") { (image) in
            guard let image = image else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            official.image = image
            self.officialsImageView.image = image
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    override func prepareForReuse() {
        officialsImageView.image = nil
    }
    
    
    
    func updateDefaultImage(official: Official) {
        
        if officialsImageView.image == nil {
            
            if official.party == "Democratic" {
                officialsImageView.image = UIImage(named: "democraticDonkey.png" )
                
            } else if  official.party == "Republican"{
                officialsImageView.image = UIImage(named: "Republican.png")
            } else if official.party == "Libertarian" {
                officialsImageView.image = UIImage(named: "Libertarian.png")
            }
        }
    }
}




