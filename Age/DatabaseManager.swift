//
//  DatabaseManager.swift
//  Age
//
//  Created by Amin on 2019-04-21.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager {
    // Singleton instance.
    static let shared = DatabaseManager()
    
    // MARK: - Other constants/types
    
    typealias Completion = (_ success: Bool) -> Void
    
    enum Entity: String {
        case BirthdayEntity
    }
    
    // MARK: - Core Data stack
    
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
    
    // MARK: - Core Data Saving support
    
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
    
    // 
    
    // Async.
    func addBirthday(_ birthday: Birthday, completion: @escaping Completion) {
        backgroundContext.perform {
            guard let BirthdayEntity = NSEntityDescription.insertNewObject(forEntityName: Entity.BirthdayEntity.rawValue, into: self.backgroundContext) as? BirthdayEntity else {
                fatalError("Failed!")
            }
            
            BirthdayEntity.birth_date = birthday.birthDate
            BirthdayEntity.name = birthday.name
            BirthdayEntity.created = Date()
            
            completion(true)
        }
    }
    
    // Sync.
    func addBirthday(_ birthday: Birthday) -> BirthdayEntity {
        guard let BirthdayEntity = NSEntityDescription.insertNewObject(forEntityName: Entity.BirthdayEntity.rawValue, into: persistentContainer.viewContext) as? BirthdayEntity else {
            fatalError("Failed!")
        }
        BirthdayEntity.birth_date = birthday.birthDate
        BirthdayEntity.name = birthday.name
        BirthdayEntity.created = Date()
        
        return BirthdayEntity
    }
    
    // method for updating a birthday.
    func updateBirthday(_ BirthdayEntity: BirthdayEntity, with newBirthday: Birthday) {
        BirthdayEntity.birth_date = newBirthday.birthDate
        BirthdayEntity.name = newBirthday.name
    }
    
    // method for remove birthday with bg context.
    func deleteBirthday(_ BirthdayEntity: BirthdayEntity) {
        persistentContainer.viewContext.delete(BirthdayEntity)
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
}
