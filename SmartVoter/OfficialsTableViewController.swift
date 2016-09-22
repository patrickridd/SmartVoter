//
//  OfficialsTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/19/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class OfficialsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var streetAddress: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet var statePickerView: UIPickerView!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateTextField.inputView = statePickerView
        blurView.hidden = true
        
        statePickerView.delegate = self
        statePickerView.dataSource = self
        
        guard let address = ProfileController.sharedController.loadAddress() else {
            blurView.hidden = false
            return
        }
        
        OfficialController.getOfficials(address) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableView), name: ProfileViewController.addressChangedNotification, object: nil)
    }
    
    
    // MARK: - Picker View Delegate Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Address.states.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Address.states[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = Address.states[row].rawValue
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfficialController.officials.count
    }
    
    // MARK: - Table view data source
    
    func reloadTableView() {
        guard let address = ProfileController.sharedController.loadAddress() else {
            blurView.hidden = false
            return
        }
        OfficialController.getOfficials(address) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("officialCell", forIndexPath: indexPath) as? OfficialTableViewCell else { return UITableViewCell() }
        
        // let office = OfficialController.offices[indexPath.row]
        let official = OfficialController.officials[indexPath.row]
        
        cell.updateOfficialsCell(official)
        
        return cell
    }
    
    // MARK: - ACTIONS
    
    @IBAction func addressSubmitButtonTapped(sender: AnyObject) {
        guard let streetAddress = streetAddress.text,
            city = cityTextField.text,
            state = stateTextField.text,
            zip = zipTextField.text else {return}
        let address = Address(line1: streetAddress, city: city, state: state, zip: zip)
        self.address = address
        OfficialController.getOfficials(address.asAString) {
            self.tableView.reloadData()
        }
        blurView.hidden = true
        ProfileController.sharedController.saveAddressToUserDefault(address.asAString)
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toOfficialDetail" {
            let viewController = segue.destinationViewController as? OfficialDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let official = OfficialController.officials[indexPath.row]
            // viewController?.address = self.address
            viewController?.official = official
            
        }
    }
}
