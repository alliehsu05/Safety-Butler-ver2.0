//
//  Record+CoreDataProperties.swift
//  Safety Butler
//
//  Created by jinrui zhang on 7/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var flame: String?
    @NSManaged public var gas: String?
    @NSManaged public var temp: Double
    @NSManaged public var time: String?

}
