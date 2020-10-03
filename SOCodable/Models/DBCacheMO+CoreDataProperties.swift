//
//  DBCacheMO+CoreDataProperties.swift
//  SOCodable
//
//  Created by Chaitanya Soni on 03/10/20.
//  Copyright © 2020 Chaitanya Soni. All rights reserved.
//
//

import Foundation
import CoreData


extension DBCacheMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<DBCacheMO> {
        return NSFetchRequest<DBCacheMO>(entityName: "DBCache")
    }

    @NSManaged public var codableType: String
    @NSManaged public var jsonString: String
    @NSManaged public var updateDate: Date
    @NSManaged public var expiryTime: Date

}
