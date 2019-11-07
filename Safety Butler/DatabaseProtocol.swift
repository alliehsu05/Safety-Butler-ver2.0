//
//  DatabaseProtocol.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import Foundation


enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case heroes
}



protocol DatabaseProtocol: AnyObject {
    func addRecord(time: String, temp: Double, gas: String, flame: String) -> Record
    func deleteRecord(record: Record)
    func fetchAllRecord() -> [Record]
    func saveContext()
}
