//
//  HomeViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 31/10/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{

    
    var name: String? = nil
    var emername: String? = nil
    var emerphone: String? = nil
    
    
    @IBOutlet weak var warningMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let loginStatus = UserDefaults.standard.bool(forKey: "launchedBefore")
        if loginStatus {
            //
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            performSegue(withIdentifier: "goToInitial", sender: self)
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkDefault()
    }
    
    //check user default
    func checkDefault() {
    
     emername = UserDefaults.standard.string(forKey: "emerName")
     emerphone = UserDefaults.standard.string(forKey: "emerPhone")
     name = UserDefaults.standard.string(forKey: "userName")
     if emername == nil || emerphone == nil {
         warningMessage.text = "Please check your Emergency Detail"
     } else{
         warningMessage.text = "Hi, \(name!)"
         }
         
     }
    
    
    
}
