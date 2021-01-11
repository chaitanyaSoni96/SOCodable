//
//  SODatabaseManager.swift
//  SOCodable
//
//  Created by Chaitanya Soni on 03/10/20.
//  Copyright © 2020 Chaitanya Soni. All rights reserved.
//

import Foundation
import CoreData

class SODatabaseManager {
    static let shared = SODatabaseManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DBCache")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
			print(storeDescription)
        })
        return container
    }()
    
    func save(codableType: String, jsonString: String, expiryTime: Date) throws {
        let updateDate = Date()
        
        let context = persistentContainer.viewContext
        let fetchRequest = DBCache.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "codableType = '\(codableType)'")
        
        let existingDBCacheArray = try? context.fetch(fetchRequest)
        
        if let existingCache = existingDBCacheArray?.first {
            
            existingCache.codableType = codableType
            existingCache.updateDate = updateDate
            existingCache.expiryTime = expiryTime
            existingCache.jsonString = jsonString
            
        } else if let dbCache = NSEntityDescription.insertNewObject(forEntityName: "DBCache", into: context) as? DBCache {
            
            dbCache.codableType = codableType
            dbCache.updateDate = updateDate
            dbCache.expiryTime = expiryTime
            dbCache.jsonString = jsonString
        }
        
        do {
            try context.save()
        } catch {
            throw SOError(message: "Save to CoreData Failed")
        }
        
    }
    
    func fetch(codableType: String) -> DBCache? {
        
        let context = persistentContainer.viewContext
        let fetchRequest = DBCache.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "codableType = '\(codableType)'")
        
        let existingDBCacheArray = try? context.fetch(fetchRequest)
        
        return existingDBCacheArray?.first
    }
    
    func deleteAll() {
        
        let context = persistentContainer.viewContext
        try? context.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "DBCache")))
        
    }
    
}
