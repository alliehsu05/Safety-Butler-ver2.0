//
//  emodalViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class emodalViewController: UIViewController, UITextFieldDelegate{

    
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var emerNameLabel: UITextField!
    @IBOutlet weak var emerPhoneLabel: UITextField!
    var access = false
    var nameIsValid = false
    var phoneIsValid = false
    var enameIsValid = false
    var ephoneIsValid = false
    var situation = 100
    var alertInfo: String = ""
    var nameInfo: String = ""
    var phoneInfo: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameLabel.delegate = self
        phoneLabel.delegate = self
        emerNameLabel.delegate = self
        emerPhoneLabel.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    /*Check validation of all inputs from user.
     Change boolean value if all validations pass.
     Set user default values in the system.
     */
    @IBAction func goMainBtn(_ sender: Any) {
        checkNameValidation()
        checkPhoneValidation()
        checkAccess()
        if access {
            userDefault.setValue(nameLabel.text!, forKey: "userName")
            userDefault.setValue(phoneLabel.text!, forKey: "userPhone")
            userDefault.setValue(emerNameLabel.text!, forKey: "emerName");
            userDefault.setValue(emerPhoneLabel.text!, forKey: "emerPhone");
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //Remove keyboard when user hit 'return' button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Check validation of names user enter.
    //The name should only contain letters with or without middle name and last name.
    func checkNameValidation(){
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$")
        let range = NSRange(location: 0, length: nameLabel.text!.utf16.count)
        let result = regex.firstMatch(in: nameLabel.text!, options: [], range: range)
        if result != nil {
            nameIsValid = true
        }
        let emerNameRange = NSRange(location: 0, length: emerNameLabel.text!.utf16.count)
        let emerNameResult = regex.firstMatch(in: emerNameLabel.text!, options: [], range: emerNameRange)
        if emerNameResult != nil {
            enameIsValid = true
        }
    }
    
    //Check validation of phone numbers user enter.
    //Numbers should be length of 10 numbers ans start with '04'.
    func checkPhoneValidation() {
        let regex = try! NSRegularExpression(pattern: "^04[0-9]{8,8}$")
        let phoneRange = NSRange(location: 0, length: phoneLabel.text!.utf16.count)
        let phoneResult = regex.firstMatch(in: phoneLabel.text!, options: [], range: phoneRange)
        if phoneResult != nil {
            phoneIsValid = true
        }
        let emerPhoneRange = NSRange(location: 0, length: emerPhoneLabel.text!.utf16.count)
        let emerPhoneResult = regex.firstMatch(in: emerPhoneLabel.text!, options: [], range: emerPhoneRange)
        if emerPhoneResult != nil {
            ephoneIsValid = true
        }
    }
    
    //Check if all user input is true.
    //If true, pass the process to next step.
    //If false, user alert to tell user where is the fail and clear all input text fields.
    func checkAccess(){
        if nameIsValid == false || enameIsValid == false {
            nameInfo = "Name should be contain only letters with or without surname."
            alertInfo = alertInfo + " " + nameInfo
        }
        if phoneIsValid == false || ephoneIsValid == false {
            phoneInfo = "Phone number should be start with 04 and its length is 10."
            alertInfo = alertInfo + " " + phoneInfo
        }
        
        if alertInfo != "" {
            let alertController = UIAlertController(title: "Input Error", message:alertInfo, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController,animated: true,completion: nil)
            clear()
            alertInfo = ""
        }
        if nameIsValid == true && enameIsValid == true && phoneIsValid == true && ephoneIsValid == true {
            access = true
        }
    }
    
    //Clear all input fields in the vc.
    func clear() {
        nameLabel.text = ""
        phoneLabel.text = ""
        emerNameLabel.text = ""
        emerPhoneLabel.text = ""
    }
}
