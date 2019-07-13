//
//  DatabaseManager.swift
//  Age
//
//  Created by Amin on 2019-04-21.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import CoreData
import AgeData

class DatabaseManager {
    
    // MARK: - Constants/Types
    
    private enum Entity: String {
        case BirthdayEntity
    }
    
    // MARK: - Static
    
    // Singleton instance.
    static let shared = DatabaseManager()
    
    // MARK: - API
    
    // MARK: Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Database Operations
    
    // Async.
    func addBirthday(_ birthday: Birthday, completion: @escaping Finish<BirthdayEntity>) {
        backgroundContext.perform {
            guard let birthdayEntity = NSEntityDescription.insertNewObject(forEntityName: Entity.BirthdayEntity.rawValue, into: self.backgroundContext) as? BirthdayEntity else {
                fatalError("Failed!")
            }
            
            birthdayEntity.year = Int16(birthday.birthDate.year)
            birthdayEntity.month = Int16(birthday.birthDate.month)
            birthdayEntity.day = Int16(birthday.birthDate.day)
            birthdayEntity.name = birthday.name
            birthdayEntity.created = Date()
            
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Unresolved error: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(birthdayEntity)
            }
        }
    }
    
    // method for updating a birthday.
    // This one could be sync I assume.
    func updateBirthday(_ birthdayEntity: BirthdayEntity, with newBirthday: Birthday) {
        birthdayEntity.year = Int16(newBirthday.birthDate.year)
        birthdayEntity.month = Int16(newBirthday.birthDate.month)
        birthdayEntity.day = Int16(newBirthday.birthDate.day)
        birthdayEntity.name = newBirthday.name
    }
    
    // method for remove birthday with bg context.
    func deleteBirthday(_ birthdayEntity: BirthdayEntity, completion: @escaping Finish<Any?>) {
        // https://stackoverflow.com/a/21245844
        let objectId = birthdayEntity.objectID
        backgroundContext.perform {
            self.backgroundContext.delete(self.backgroundContext.object(with: objectId))
            
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Unresolved error: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    /// A fetchedResultsController.
    ///
    /// - Returns: FetchResultsController for the list of the birthdays.
    lazy var birthdaysFetchResultsController: NSFetchedResultsController<BirthdayEntity> = {
        let fetchRequest = NSFetchRequest<BirthdayEntity>(entityName: Entity.BirthdayEntity.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error: \(error)")
        }
        return controller
    }()
    
    // MARK: - Life Cycle
    
    // In order to avoid instances other than `shared` to be created for this type.
    private init() { }
    
    // MARK: - Properties
    
    // MARK: Core Data stack
    
    lazy private(set) var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Age")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Merge the changes from other contexts automatically.
        // See this sample code for more details:
        // https://developer.apple.com/documentation/coredata/loading_and_displaying_a_large_data_feed
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        return container
    }()
    
    // In order to do things asyncronously.
    lazy private var backgroundContext: NSManagedObjectContext = {
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        return taskContext
    }()
}
