//
//  HomeViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 31/10/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var name: String? = nil
    var emername: String? = nil
    var emerphone: String? = nil
    
    
    @IBOutlet weak var warningMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*emername = UserDefaults.standard.string(forKey: "emerName")
        emerphone = UserDefaults.standard.string(forKey: "emerPhone")
        print(emername)
        print(emerphone)
        if emername == nil || emerphone == nil {
            warningMessage.text = ""
        } else{
            warningMessage.text = "Hello, Mr Bean!"
        }
        */
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let loginStatus = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if loginStatus {
            /*
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            performSegue(withIdentifier: "goToInitial", sender: self)
            */
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            performSegue(withIdentifier: "goToInitial", sender: self)
        }
        
        emername = UserDefaults.standard.string(forKey: "emerName")
        emerphone = UserDefaults.standard.string(forKey: "emerPhone")
        name = UserDefaults.standard.string(forKey: "userName")
        print(emername)
        print(emerphone)
        if emername == nil || emerphone == nil {
            warningMessage.text = "You have not set the emergency contact yet."
        } else{
            warningMessage.text = "Hello, \(name!)"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "situationSegue"{
            let destination = segue.destination as! situationViewController
        }
    }

}
