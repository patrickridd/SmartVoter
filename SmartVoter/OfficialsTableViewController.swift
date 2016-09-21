//
//  OfficialsTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class OfficialsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var addressInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.hidden = true
        guard let address = ProfileController.sharedController.loadAddress() else {
            blurView.hidden = false
            return
        }
        OfficialController.getOfficials(address) { 
            self.tableView.reloadData()
        }
        
    }


    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfficialController.officials.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("officialCell", forIndexPath: indexPath) as? OfficialTableViewCell
        
        let office = OfficialController.offices[indexPath.row]
        let official = OfficialController.officials[indexPath.row]
        
        cell?.updateOfficialsCell(office, official: official)
        
        return cell ?? UITableViewCell()
    }
    
    
    @IBAction func addressSubmitButtonTapped(sender: AnyObject) {
        guard let address = addressInput.text else {return}
        OfficialController.getOfficials(address) { 
            self.tableView.reloadData()
        }
        blurView.hidden = true
        ProfileController.sharedController.saveAddressToUserDefault(address)
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toOfficialDetail" {
            
            
            
        }
        
    }
 

}
