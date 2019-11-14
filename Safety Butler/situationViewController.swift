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

    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var flameLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    
    let firebaseController = FirebaseController()
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
        
        //repeat update function
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    
    @objc func update(){
        conditionList = firebaseController.returnList()
        
        let index = conditionList!.count - 1
        if index != -1 {

            //notification
            let content = UNMutableNotificationContent()
            content.title = "Danger"
            content.body = "Temperature and Air Condition are abnormal"
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            
            currentTemp = conditionList![index].getTemp()
            currentGas = conditionList![index].getGas()
            currentFlame = conditionList![index].getFlame()
            
            //set situation text
            if currentGas == 1 {
                situationGas="No Smoke"
            }else{
                situationGas="Smoke detected"
                status = 1
            }
            
            if currentFlame == 1 {
                situationFlame="No Flame"
            }else{
                situationFlame="Flame detected"
                status = 1
            }
            
            //set text
            tempLabel.text = "\(currentTemp!)"
            gasLabel.text = situationGas
            flameLabel.text = situationFlame
            
            
            //checking situation, setting text content and color based on situation
            //if it is not safe, save record into core data
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
                    //if potential fire happen, sent notification
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        
        //abnormal status list
        if checkList.count < 10 {
            checkList.append(status!)
            status = 0
        } else {
            checkList.remove(at: 0)
            checkList.append(status!)
            status = 0
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
            total = value + total
        }
        //if abnormal record more than 5, displayMessage
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
        
        if number != nil && userName != nil && emerName != nil {
            composeVC.recipients = [number!]
            composeVC.body = "Hi, \(emerName!). \(userName!) is having a fire. Please call the fire alarm."
            
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
            } else {
                print("Can not send message.")
            }
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //
    }
    
    
}
