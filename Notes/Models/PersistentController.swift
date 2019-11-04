//
//  PersistentController.swift
//  Notes
//
//  Created by Harut Mikichyan on 11/2/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import CoreData

final class PersistentController {
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveMainContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        try? context.save()
        DispatchQueue.main.async {
            self.persistentContainer.viewContext.refreshAllObjects()
        }
    }
}
