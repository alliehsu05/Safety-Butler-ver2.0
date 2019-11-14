//
//  recordTableViewController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit
import CoreData

class recordTableViewController: UITableViewController {
    
    var allRecords: [Record] = []
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRecrod()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allRecords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recordcell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordTableViewCell
        let record = allRecords[indexPath.row]
        let situation: String?
        
        if record.flame == "No Flame"{
            if record.gas == "No Smoke"{
                situation = "No Smoke and Flame"
            }else{
                situation = "Smoke detected"
            }
        }else{
            if record.gas == "No Smoke"{
                situation = "Flame detected"
            }else{
                situation = "Smoke and Flame detected"
            }
        }
        
        //set record cell text
        recordcell.dateLabel.text = "\(record.time!)"
        recordcell.situationLabel.text = "\(situation!)"
        return recordcell
    }
    
    //get abnormal situation record
    func getRecrod(){
        allRecords = []
        allRecords = databaseController!.fetchAllRecord()
        
    }
}
