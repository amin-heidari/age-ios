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
    static let shared = DatabaseManager()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
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
        return container
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
    
    // method for add birthday with bg context.
    func addBirthday(_ birthday: Birthday) -> BirthdayModel {
        guard let birthdayModel = NSEntityDescription.insertNewObject(forEntityName: "Birthday", into: persistentContainer.viewContext) as? BirthdayModel else {
            fatalError("Failed!")
        }
        birthdayModel.birth_date = birthday.birthDate
        birthdayModel.name = birthday.name
        birthdayModel.created = Date()
        
        return birthdayModel
    }
    
    // method for updating a birthday.
    func updateBirthday(_ birthdayModel: BirthdayModel, with newBirthday: Birthday) {
        birthdayModel.birth_date = newBirthday.birthDate
        birthdayModel.name = newBirthday.name
    }
    
    // method for remove birthday with bg context.
    func deleteBirthday(_ birthdayModel: BirthdayModel) {
        persistentContainer.viewContext.delete(birthdayModel)
    }
    
    /// A fetchedResultsController.
    ///
    /// - Returns: FetchResultsController for the list of the birthdays.
    lazy var birthdays: NSFetchedResultsController<BirthdayModel> = {
        let fetchRequest = NSFetchRequest<BirthdayModel>(entityName: "Birthday")
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
