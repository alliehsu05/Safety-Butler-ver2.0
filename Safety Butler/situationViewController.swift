//
//  situationViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 31/10/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit
import UserNotifications
import MessageUI

class situationViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //
    }
    

    let firebaseController = FirebaseController()
    
    

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var flameLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    
    var name: String?
    var phone: String?
    var emername: String?
    var emerphone: String?
    var conditionList:[Cond]?
    weak var databaseController: DatabaseProtocol?
    var currentTemp: Double?
    var currentGas: Int?
    var currentFlame: Int?
    var situationGas: String?
    var situationFlame: String?
    var checkList: [Int] = []
    var status: Int? = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController
        
              
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    
    @objc func update(){
        conditionList = firebaseController.returnList()
        let index = conditionList!.count - 1
        if index != -1 {

        currentTemp = conditionList![index].getTemp()
        currentGas = conditionList![index].getGas()
        currentFlame = conditionList![index].getFlame()
        
  
              if currentGas == 1 {
                  situationGas="No Smoke"
                    status = 1
              }else{
                  situationGas="Smoke detected"
              }
              
              if currentFlame == 1 {
                  situationFlame="No Flame"
                status = 1
              }else{
                  situationFlame="Flame detected"
              }
              
              tempLabel.text = "\(currentTemp!)"
              gasLabel.text = situationGas
              flameLabel.text = situationFlame
              
              
              
              if currentTemp! < 50{
                  if currentGas == 1 && currentFlame == 1{
                      iconView.image = UIImage(named: "8")
                      situationLabel.text = "Safe"
                      situationLabel.textColor = UIColor.green
                      
                  }else if currentGas == 1 && currentFlame == 0{
                    iconView.image = UIImage(named: "7")
                    situationLabel.text = "Potential Flame"
                    situationLabel.textColor = UIColor.orange
                    createRecrod()
                  }else if currentGas == 0 && currentFlame == 1{
                    iconView.image = UIImage(named: "6")
                    situationLabel.text = "Potential Smoke"
                    situationLabel.textColor = UIColor.orange
                    createRecrod()
                }else if currentGas == 0 && currentFlame == 0{
                    iconView.image = UIImage(named: "5")
                    situationLabel.text = "Potential Risk"
                    situationLabel.textColor = UIColor.orange
                    createRecrod()
                }
                    
                }else if currentTemp! >= 50{
                status = 1
                if currentGas == 1 && currentFlame == 1{
                      iconView.image = UIImage(named: "4")
                      situationLabel.text = "Overhigh Temperature"
                      situationLabel.textColor = UIColor.orange
                      createRecrod()
                  }else if currentGas == 1 && currentFlame == 0{
                    iconView.image = UIImage(named: "3")
                    situationLabel.text = "Overhigh Temperature and Potential Flame"
                    situationLabel.textColor = UIColor.orange
                    createRecrod()
                  }else if currentGas == 0 && currentFlame == 1{
                      iconView.image = UIImage(named: "2")
                      situationLabel.text = "Overhigh Temperature and Potential Smoke"
                      situationLabel.textColor = UIColor.orange
                      createRecrod()
                  }else if currentGas == 0 && currentFlame == 0{
                      iconView.image = UIImage(named: "1")
                      situationLabel.text = "Danger! Potential Fire!"
                      situationLabel.textColor = UIColor.red
                      createRecrod()
                  }
            }
        }
        

    
            if checkList.count < 10 {
            checkList.append(status!)
            } else {
                checkList.remove(at: 0)
                checkList.append(status!)
            }
            
            getStatus()
        
        
    }
    
    func createRecrod(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "Australia/Sydney")
        let strdate = dateFormatter.string(from: date)
        print(strdate)
        let _ = databaseController!.addRecord(time: strdate, temp: currentTemp!, gas: situationGas!, flame: situationFlame!)
        
    }
    
    func getStatus() {
        var total: Int = 0
        for value in checkList{
            total += value
        }
        if checkList.count >= 5 && total == checkList.count{
            displayMessage()
        }
    }
    
    func displayMessage() {
        let composeVC:MFMessageComposeViewController = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        let number = UserDefaults.standard.string(forKey: "emerPhone")
        let userName = UserDefaults.standard.string(forKey: "userName")
        let emerName = UserDefaults.standard.string(forKey: "emerName")
        
        
        composeVC.recipients = [number!]
        composeVC.body = "Hi, \(emerName!). \(userName!) is having a fire. Please call the fire alarm."
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can not send message.")
        }
    /*
        if number != nil && userName != nil && emerName != nil {
        let alertController = UIAlertController(title: "Alarm", message: "Hi, \(emerName!). \(userName!) is having a fire. Please call the fire alarm.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true,completion: nil)
        }
 */
    }
    

}
