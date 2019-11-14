//
//  contactViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 31/10/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class contactViewController: UIViewController, UITextFieldDelegate {
    
    var access: Bool = false
    var nameIsValid: Bool = false
    var phoneIsValid: Bool = false
    var enameIsValid: Bool = false
    var ephoneIsValid: Bool = false
    let userDefault = UserDefaults.standard
    var alertInfo: String = ""
    var nameInfo: String = ""
    var phoneInfo: String = ""
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var emernameText: UITextField!
    @IBOutlet weak var emerphoneText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.delegate = self
        phoneText.delegate = self
        emernameText.delegate = self
        emerphoneText.delegate = self
        
        let name = userDefault.string(forKey: "userName")
        let phone = userDefault.string(forKey: "userPhone")
        let emername = userDefault.string(forKey: "emerName")
        let emerphone = userDefault.string(forKey: "emerPhone")
        
        if name != nil && phone != nil && emername != nil && emerphone != nil {
            nameText.placeholder = "\(name!)"
            phoneText.placeholder = "\(phone!)"
            emernameText.placeholder = "\(emername!)"
            emerphoneText.placeholder = "\(emerphone!)"
        }
        // Do any additional setup after loading the view.
    }
    
    
    //Remove keyboard when user hit 'return' button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Update the information to user default
    @IBAction func update(_ sender: Any) {
        checkNameValidation()
        checkPhoneValidation()
        checkAccess()
        if access {
            userDefault.setValue(nameText.text!, forKey: "userName")
            userDefault.setValue(phoneText.text!, forKey: "userPhone")
            userDefault.setValue(emernameText.text!, forKey: "emerName");
            userDefault.setValue(emerphoneText.text!, forKey: "emerPhone");
        }
        navigationController?.popViewController(animated: true)
        return
    }
    
    //Check if all name inputs follow the validation.
    //Validation of name is user should only input letters and names take with/without middle name and last name.
    func checkNameValidation(){
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$")
        let range = NSRange(location: 0, length: nameText.text!.utf16.count)
        let result = regex.firstMatch(in: nameText.text!, options: [], range: range)
        if result != nil {
            nameIsValid = true
        }
        let emerNameRange = NSRange(location: 0, length: emernameText.text!.utf16.count)
        let emerNameResult = regex.firstMatch(in: emernameText.text!, options: [], range: emerNameRange)
        if emerNameResult != nil {
            enameIsValid = true
        }
    }
    
    //Check if all number inputs follow the validation.
    //Validation of numer is user should only input numbers and number should be 10 numbers-long and start with '04'.
    func checkPhoneValidation() {
        let regex = try! NSRegularExpression(pattern: "^04[0-9]{8,8}$")
        let phoneRange = NSRange(location: 0, length: phoneText.text!.utf16.count)
        let phoneResult = regex.firstMatch(in: phoneText.text!, options: [], range: phoneRange)
        if phoneResult != nil {
            phoneIsValid = true
        }
        let emerPhoneRange = NSRange(location: 0, length: emerphoneText.text!.utf16.count)
        let emerPhoneResult = regex.firstMatch(in: emerphoneText.text!, options: [], range: emerPhoneRange)
        if emerPhoneResult != nil {
            ephoneIsValid = true
        }
    }
    
    //Check if all input follow the validation rules.
    //If so, set the data to user default.
    //If not, send according alert and clear all text fields.
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
    
    //Clear all text fields in VC.
    func clear() {
        nameText.text = ""
        phoneText.text = ""
        emernameText.text = ""
        emerphoneText.text = ""
    }
}

