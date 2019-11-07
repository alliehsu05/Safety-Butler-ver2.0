//
//  emodalViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class emodalViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goMainBtn(_ sender: Any) {
        checkNameValidation()
        checkPhoneValidation()
        checkAccess()
        if access {
            userDefault.setValue(nameLabel.text!, forKey: "userName")
            userDefault.setValue(phoneLabel.text!, forKey: "userPhone")
            userDefault.setValue(emerNameLabel.text!, forKey: "emerName");
            userDefault.setValue(emerPhoneLabel.text!, forKey: "emerPhone");
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            self.presentingViewController?.reloadInputViews()
        }
        
    }
    
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
    
    func checkAccess(){
        if nameIsValid == false || enameIsValid == false {
            let alertController = UIAlertController(title: "Name Error", message: "Name should be contain only letters with or without surname.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController,animated: true,completion: nil)
            clear()
        }
        if nameIsValid == false || enameIsValid == false {
            let alertController = UIAlertController(title: "Phone Number Error", message: "Phone number should be start with 04 and its length is 10.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController,animated: true,completion: nil)
            clear()
        }
        if nameIsValid == true && enameIsValid == true && phoneIsValid == true && ephoneIsValid == true {
            access = true
        }
    }
    func clear() {
        nameLabel.text = ""
        phoneLabel.text = ""
        emerNameLabel.text = ""
        emerPhoneLabel.text = ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
