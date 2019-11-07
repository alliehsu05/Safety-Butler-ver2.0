//
//  CoreDataController.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {


    var persistantContainer: NSPersistentContainer
    var allRecordsFetchedResultsController: NSFetchedResultsController<Record>?
    
    override init() {
        persistantContainer = NSPersistentContainer(name: "Record")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack: \(error)")
            }
        }

        super.init()
        
      
    }
    //save any change for database
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    //adding to core data
    func addRecord(time: String, temp: Double, gas: String, flame: String) -> Record{
        let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: persistantContainer.viewContext) as! Record
        record.time = time
        record.temp = temp
        record.gas = gas
        record.flame = flame
   
        
        saveContext()
       // print(record)
        return record
        
    }

    
    func deleteRecord(record: Record) {
        persistantContainer.viewContext.delete(record)
        
        saveContext()
    }

    
    
    func fetchAllRecord() -> [Record] {
        if allRecordsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            let timeSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            fetchRequest.sortDescriptors = [timeSortDescriptor]
           
        
            allRecordsFetchedResultsController = NSFetchedResultsController<Record>(fetchRequest: fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allRecordsFetchedResultsController?.delegate = self
            
            do {
                try allRecordsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var records = [Record]()
        if allRecordsFetchedResultsController?.fetchedObjects != nil {
            records = (allRecordsFetchedResultsController?.fetchedObjects)!
        }

        return records
    }

    


    }
