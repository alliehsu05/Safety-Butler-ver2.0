//
//  DatabaseProtocol.swift
//  Safety Butler
//
//  Created by jinrui zhang on 4/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import Foundation


//Do changes, add/delete/fetch/save to CoreData.
protocol DatabaseProtocol: AnyObject {
    func addRecord(time: String, temp: Double, gas: String, flame: String) -> Record
    func deleteRecord(record: Record)
    func fetchAllRecord() -> [Record]
    func saveContext()
}
