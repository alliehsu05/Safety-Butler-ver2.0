//
//  FirebaseController.swift
//  Safety Butler
//
//  Created by Chia-Yu Hsu on 3/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseController: NSObject {
    var authController: Auth
    var database: Firestore
    var dataRef: CollectionReference?
    var temp: Double?
    var gas: Int?
    var flame: Int?
    var condList:[Cond] = []
    
    //Get connection to Firebase
    override init(){
        authController = Auth.auth()
        database = Firestore.firestore()
        
        super.init()
        
        authController.signInAnonymously(){(authResult, error) in
            guard authResult != nil else{
                fatalError("Firebase authentication failed")
            }
            self.setUpListeners()
        }
    }
    
    //Method to do GET request from Firebase
    
    func setUpListeners(){
        //Unique collection id.
        dataRef = database.collection("user00001")
        dataRef?.addSnapshotListener{ querySnapshot, error in
            guard (querySnapshot?.documents) != nil else{
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseDataSnapshot(snapshot: querySnapshot!)
        }
        
    }
    
    //Get the colors indexes from firebase
    func parseDataSnapshot(snapshot: QuerySnapshot){
        snapshot.documentChanges.forEach{ change in
            if change.document.data()["temp"] != nil && change.document.data()["co"] != nil && change.document.data()["flame"] != nil{
                temp = change.document.data()["temp"] as? Double
                gas = change.document.data()["co"] as? Int
                flame = change.document.data()["flame"] as? Int
                addToList()
            }
        }
    }
    
    
    func addToList() {
        let condition: Cond = Cond(temp: temp!, gas: gas!, flame: flame!)
        condList.append(condition)
    }
    
    func getTemp() -> Double{
        return temp!
    }
    
    func getGas() -> Int{
        return gas!
    }
    
    func getFlame() -> Int{
        return flame!
    }
    
    func returnList() -> [Cond]{
        return condList
    }
    
    
}

