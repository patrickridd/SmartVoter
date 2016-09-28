//
//  SettingsTableViewController.swift
//  SmartVoter
//
//  Created by Patrick Ridd on 9/27/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//
extension UITextField {
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .Next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), forControlEvents: .EditingDidEndOnExit)
        }
        last.returnKeyType = .Done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), forControlEvents: .EditingDidEndOnExit)
    }
}


import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var updateLabel: UIButton!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var livingAddress: UILabel!
    @IBOutlet weak var capitolImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var datePicker: UIPickerView!
    @IBOutlet weak var saveButtonLabel: UIBarButtonItem!
    @IBOutlet weak var doneButtonLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        guard let address = ProfileController.sharedController.loadAddress() else {
            return
        }
        updateLivingAddressLabel(address)
        setupView()
        setupTextFields()
        setupKeyboardNotifications()
        
        datePicker.backgroundColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 0.6)
    }

  
    @IBAction func updateAddressButtonTappedWithSender(sender: AnyObject) {
        doneButtonLabel.title = "Cancel"
        saveButtonLabel.title = "Save"
        saveButtonLabel.enabled = true
        blurView.hidden = false
        capitolImage.hidden = false
        stateTextField.hidden = false
        streetTextField.hidden = false
        cityTextField.hidden = false
        zipTextField.hidden = false
        
    }
    
    @IBAction func doneButtonTappedWithSender(sender: AnyObject) {
        if doneButtonLabel.title == "Cancel" {
           setupView()
            zipTextField.resignFirstResponder()
            streetTextField.resignFirstResponder()
            cityTextField.resignFirstResponder()
            stateTextField.resignFirstResponder()
        } else {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        }
    }
    
    @IBAction func saveButtonTappedWithSender(sender: AnyObject) {
        stateTextField.resignFirstResponder()
        zipTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        streetTextField.resignFirstResponder()
        guard let stateText = stateTextField.text where stateText.characters.count > 0,
            let cityText = cityTextField.text where cityText.characters.count > 0,
            let streetText = streetTextField.text where streetText.characters.count > 0,
            let zipText = zipTextField.text where zipText.characters.count > 0  else {
                
                self.setupView()
                return
        }
        let newAddress = Address(line1: streetText, city: cityText, state: stateText, zip: zipText)
        ProfileController.sharedController.saveAddressToUserDefault(newAddress)
        updateLivingAddressLabel(newAddress)
        setupView()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(ProfileViewController.addressChangedNotification, object: self)
        })

    }
    
    func updateLivingAddressLabel(address: Address) {
        self.livingAddress.text = address.asAString
    }
    

    func setupView() {
        doneButtonLabel.title = "Done"
        saveButtonLabel.title = ""
        saveButtonLabel.enabled = false
        blurView.hidden = true
        capitolImage.hidden = true
        stateTextField.hidden = true
        streetTextField.hidden = true
        cityTextField.hidden = true
        zipTextField.hidden = true
    }
    
    /// Sets delegate for textFields
    func setupTextFields() {
        streetTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        datePicker.delegate = self
        datePicker.dataSource = self
        stateTextField.inputView = datePicker
    }
    
    var keyboardShown = false
    var keyboardHeight: CGFloat?
    
    func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            raiseView(keyboardSize.height)
        }
    }
    
    func raiseView(height: CGFloat) {
        if !keyboardShown {
            view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - height)
            keyboardShown = true
        } else {
            guard let keyBoardHeight = keyboardHeight else {
                return
            }
            if keyBoardHeight > height {
                let differenceHeight = keyBoardHeight - height
                view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height + differenceHeight)
            } else {
                let differenceHeight = height - keyBoardHeight
                view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - differenceHeight)
            }
        }
        keyboardHeight = height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height + keyboardSize.height)
            keyboardShown = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UITextField.connectFields([streetTextField,cityTextField,stateTextField,zipTextField])
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height-60
    }
    
    // MARK: - PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Address.states.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = Address.states[row].rawValue
        let title = NSAttributedString(string: titleData, attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 15.0)!,NSForegroundColorAttributeName: UIColor.whiteColor()])
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = Address.states[row].rawValue
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
