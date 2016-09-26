//
//  OfficialsTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class OfficialsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var address: Address?
    let logo = UIImage(named: "Logo Large")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: SignUpViewController.addressAddedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: ProfileViewController.addressChangedNotification, object: nil)
        
        guard let address = ProfileController.sharedController.loadAddress() else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let signUpViewController = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController else {return}
            self.presentViewController(signUpViewController, animated: true, completion: nil)
            return
        }
        
        OfficialController.getOfficials(address.asAString) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        
       
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return OfficialController.sortedOfficials.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfficialController.sortedOfficials[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("officialCell", forIndexPath: indexPath) as? OfficialTableViewCell else { return UITableViewCell() }
        
        let official = OfficialController.sortedOfficials[indexPath.section][indexPath.row]
        
        cell.updateOfficialsCell(official)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String = ""
        
        switch section {
        case 0:
            title = "Federal"
        case 1:
            title = "State"
        case 2:
            title = "Local"
        default:
            title = "Section"
        }
        return title
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let blueColor = UIColor.bradsBlue()
        let font = UIFont(name: "avenir", size: 18)
        
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = blueColor
        header.textLabel?.font = font
        header.textLabel?.textColor = .whiteColor()
    }
    
    func reloadTableView() {
        guard let address = ProfileController.sharedController.loadAddress() else {
            return
        }
        OfficialController.getOfficials(address.asAString) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - ACTIONS
    
//    @IBAction func addressSubmitButtonTapped(sender: AnyObject) {
//        guard let streetAddress = streetAddress.text,
//            city = cityTextField.text,
//            state = stateTextField.text,
//            zip = zipTextField.text else {return}
//        let address = Address(line1: streetAddress, city: city, state: state, zip: zip)
//        self.address = address
//        OfficialController.getOfficials(address.asAString) {
//            self.tableView.reloadData()
//        }
//        blurView.hidden = true
//        ProfileController.sharedController.saveAddressToUserDefault(address)
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toOfficialDetail" {
            guard let viewController = segue.destinationViewController as? OfficialDetailViewController, indexPath = tableView.indexPathForSelectedRow else { return }
            let official = OfficialController.sortedOfficials[indexPath.section][indexPath.row]
            viewController.official = official
        }
    }
}
