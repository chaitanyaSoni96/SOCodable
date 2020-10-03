//
//  SOCodable.swift
//  SOCodable
//
//  Created by Chaitanya Soni on 03/10/20.
//  Copyright © 2020 Chaitanya Soni. All rights reserved.
//

import Foundation


//let expiryTime: TimeInterval = 60 * 60 * 24 * 7 //in seconds - a week (secs * mins * hrs * days)



class SOCodable: NSObject & Codable {
    var expiryTime: TimeInterval = 60 * 60 * 24 * 7 //in seconds - a week (secs * mins * hrs * days)
    
}



extension SOCodable {
    func saveToDisk() throws {
        guard let jsonString = self.stringValue else {
            throw SOError(message: "Invalid Codable")
        }
        do {
            try SODatabaseManager.shared.save(codableType: self.className,
                                            jsonString: jsonString,
                                            expiryTime: Date().addingTimeInterval(self.expiryTime))
        } catch {
            throw SOError(message: "Save to CoreData Failed")
        }
    }
    
    func getFromDisk(ignoresExpiry: Bool = false) -> Self? {
        let dbCache = SODatabaseManager.shared.fetch(codableType: self.className)
        
        let whenDataExpires = (dbCache?.updateDate.addingTimeInterval(expiryTime) as Date? ?? Date.init(timeIntervalSince1970: 0)) as Date
        let dateTimeNow = Date()
        
        let expired = dateTimeNow > whenDataExpires
        
        let dataFromDB: Self? = Self.fromDict(dbCache?.jsonString.convertToDictionary() ?? [:])
        return ignoresExpiry ? dataFromDB : expired ? nil : dataFromDB
    }
}



//extension Encodable where Self: NSObject & Decodable {
//
//
//    static func getFromDisk(ignoreExpiry: Bool = false) -> Self? { // gets from disk if exists
//        let someRawData = Self.rawData()
//        let whenDataExpires = (someRawData?.updateDate.addingTimeInterval(expiryTime) as Date? ?? Date.init(timeIntervalSince1970: 0)) as Date
//        let dateTimeNow = Date()
//
//        let expired = dateTimeNow > whenDataExpires
//
//        let dataFromDB: Self? = Self.fromDict(someRawData?.jsonString.convertToDictionary() ?? [:])
//        return ignoreExpiry ? dataFromDB : expired ? nil : dataFromDB
//    }
//
//    static func deleteFromDisk() { //deletes if exists
//        let realm = Realm.safeInstance()
//        if let existing = Self.rawData() {
//            try? realm.write({
//                realm.delete(existing)
//            })
//        }
//    }
//
//    static func saveToDisk(data: Self?) { //saves or updates existing
//        guard let data = data else {
//            return
//        }
//        let now = Date()
//        if let stringVal = data.stringValue {
//
//            let realm = Realm.safeInstance()
//
//            let cache = realm.objects(DBCache.self)
//
//            if let existingData = cache.filter ({ $0.codableType == data.className }).first {
//
//                try? realm.write({
//
//                    existingData.updateDate = now as NSDate
//                    existingData.jsonString = stringVal
//                })
//            } else {
//
//                try? realm.write({
//
//                    let dbCache = DBCache()
//                    dbCache.codableType = data.className
//                    dbCache.jsonString = stringVal
//                    dbCache.updateDate = now as NSDate
//                    realm.add(dbCache)
//                })
//            }
//        }
//    }
//    static func rawData() -> DBCache? {
//        let realm = Realm.safeInstance()
//        let cache = realm.objects(DBCache.self)
//        let existingData = cache.filter ({ $0.codableType == self.init().className }).first
//        return existingData
//    }
//
//    static func rawFromDB<T: NSObject & Codable>() -> T? {
//
//        let rawData = self.rawData()
//        let dataFromDB: T? = self.fromDict(rawData?.jsonString.convertToDictionary() ?? [:])
//        return dataFromDB
//
//
//    }
//}
//
//extension Encodable where Self: NSObject {
//
//
//
//
//
//
//
//}
//@objcMembers class DBCache: Object {
//
//    dynamic var codableType: String = ""
//    dynamic var jsonString: String = ""
//    dynamic var updateDate: NSDate = NSDate()
//}
