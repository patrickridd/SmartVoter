//
//  SignUpViewController.swift
//  SmartVoter
//
//  Created by Steven Patterson on 9/23/16.
//  Copyright © 2016 PatrickRidd. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    static let addressAddedNotification = "addressAddedNotification"
    
    let toolbarView = UIView(frame: CGRectMake(0, 0, 10, 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateText.keyboardAppearance = .Default
        
        let statePicker = UIPickerView()
        statePicker.backgroundColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 0.6)
        
        statePicker.delegate = self
        statePicker.dataSource = self
        stateText.inputView = statePicker
        textfieldDelegates()
        roundedEdges()
        toolbarView.backgroundColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 0.7)
        setupKeyboardAccessoryView()
        customToolbarView()
    }
    
    
    func customToolbarView() {
        
        let doneButton = UIButton()
        let forward = UIButton()
        let back = UIButton()
        
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        back.translatesAutoresizingMaskIntoConstraints = false
        forward.translatesAutoresizingMaskIntoConstraints = false
        
        
        doneButton.backgroundColor = .clearColor()
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(.whiteColor(), forState: .Normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), forControlEvents: .TouchUpInside)
        
        forward.backgroundColor = .clearColor()
        forward.setTitle("Next", forState: .Normal)
        forward.setTitleColor(.whiteColor(), forState: .Normal)
        forward.addTarget(self, action: #selector(forwardButtonTapped), forControlEvents: .TouchUpInside)
        
        back.backgroundColor = .clearColor()
        back.setTitle("Prev", forState: .Normal)
        back.setTitleColor(.whiteColor(), forState: .Normal)
        back.addTarget(self, action: #selector(backButtonTapped), forControlEvents: .TouchUpInside)

        let testView = UIView()
        testView.backgroundColor = .whiteColor()
        
        toolbarView.addSubview(doneButton)
        toolbarView.addSubview(forward)
        toolbarView.addSubview(back)
        toolbarView.addSubview(testView)
        
        doneButton.centerXAnchor.constraintEqualToAnchor(toolbarView.trailingAnchor, constant: -30).active = true
        doneButton.centerYAnchor.constraintEqualToAnchor(toolbarView.centerYAnchor).active = true
        doneButton.widthAnchor.constraintEqualToConstant(50)
        doneButton.heightAnchor.constraintEqualToConstant(20).active = true
        
        back.centerXAnchor.constraintEqualToAnchor(toolbarView.leadingAnchor, constant: +28).active = true
        back.centerYAnchor.constraintEqualToAnchor(toolbarView.centerYAnchor).active = true
        back.widthAnchor.constraintEqualToConstant(50).active = true
        back.heightAnchor.constraintEqualToConstant(20).active = true
        
        forward.centerXAnchor.constraintEqualToAnchor(toolbarView.leadingAnchor, constant: +80).active = true
        forward.centerYAnchor.constraintEqualToAnchor(toolbarView.centerYAnchor).active = true
        forward.widthAnchor.constraintEqualToConstant(50).active = true
        forward.heightAnchor.constraintEqualToConstant(20).active = true
       
    }
    
    func doneButtonTapped(sender: UIButton!) {
        print("Done Button Tapped")
        [streetText, cityText, stateText, zipText].forEach { (textField) in
            textField.resignFirstResponder()
        }
    }
    
    func forwardButtonTapped(sender: UIButton!)  {
        if streetText.isFirstResponder() {
            cityText.becomeFirstResponder()
        } else if cityText.isFirstResponder() {
            stateText.becomeFirstResponder()
        } else if stateText.isFirstResponder() {
            zipText.becomeFirstResponder()
        } else {
            zipText.resignFirstResponder()
        }
    }
    
    func backButtonTapped(sender: UIButton!) {
        if zipText.isFirstResponder() {
            stateText.becomeFirstResponder()
        } else if stateText.isFirstResponder() {
            cityText.becomeFirstResponder()
        } else if cityText.isFirstResponder() {
            streetText.becomeFirstResponder()
        } else {
            streetText.resignFirstResponder()
        }
    }
    
    func setupKeyboardAccessoryView() {
        streetText.inputAccessoryView = toolbarView
        cityText.inputAccessoryView = toolbarView
        stateText.inputAccessoryView = toolbarView
        zipText.inputAccessoryView = toolbarView
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitButtonTappedWithSender(sender: AnyObject) {
        guard let streetAddress = streetText.text,
            city = cityText.text,
            state = stateText.text,
            zip = zipText.text else {return}
        let address = Address(line1: streetAddress, city: city, state: state, zip: zip)
        ProfileController.sharedController.saveAddressToUserDefault(address)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(SignUpViewController.addressAddedNotification, object: self)
        })
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func textfieldDelegates() {
        streetText.delegate = self
        cityText.delegate = self
        zipText.delegate = self
    }
    

    // MARK: - Making things Pretty
    
    func roundedEdges() {
        submitButton.layer.cornerRadius = 7
        streetText.layer.cornerRadius = 7
        cityText.layer.cornerRadius = 7
        stateText.layer.cornerRadius = 7
        zipText.layer.cornerRadius = 7
        
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
        stateText.text = Address.states[row].rawValue
    }
}
