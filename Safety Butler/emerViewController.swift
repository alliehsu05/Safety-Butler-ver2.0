//
//  emerViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class emerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toMainBtn(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
