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
    @IBOutlet var statePicker: UIPickerView!
    
    static let addressAddedNotification = "addressAddedNotification"
    
    let toolbarView = UIView(frame: CGRectMake(0, 0, 10, 40))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateText.inputView = statePicker
        statePicker.delegate = self
        statePicker.dataSource = self
        textfieldDelegates()
        roundedEdges()
        toolbarView.backgroundColor = .redColor()
        setupKeyboardAccessoryView()
        
    }
    
    
    func customToolbarView() {
        
        let doneButton = UIButton(frame: CGRect(x: , y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        let forward = UIButton()
        let back = UIButton()
        
        doneButton.backgroundColor = .clearColor()
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(.blackColor(), forState: .Normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), forControlEvents: .TouchUpInside)
        
        forward.backgroundColor = .clearColor()
        forward.setTitle(">", forState: .Normal)
        forward.setTitleColor(.blackColor(), forState: .Normal)
        forward.addTarget(self, action: #selector(forwardButtonTapped), forControlEvents: .TouchUpInside)
        
        back.backgroundColor = .clearColor()
        back.setTitle("<", forState: .Normal)
        back.setTitleColor(.blackColor(), forState: .Normal)
        back.addTarget(self, action: #selector(backButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func doneButtonTapped(sender: UIButton!) {
        
    }
    
    func forwardButtonTapped(sender: UIButton!) {
        
    }
    
    func backButtonTapped(sender: UIButton!) {
        
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Address.states[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateText.text = Address.states[row].rawValue
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
