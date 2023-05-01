//
//  CoreDataStack.swift
//  EdApp4182
//
//  Created by NikoS on 15.08.2022.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared: CoreDataStack = {
        guard let modelURL = Bundle(for: CoreDataStack.self).url(forResource: AppConstants.dataModel, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                  fatalError("No Core Data stack")
              }
        let persistentContainer = NSPersistentContainer(name: AppConstants.dataModel, managedObjectModel: managedObjectModel)
        
        return CoreDataStack(persistentContainer: persistentContainer)
    }()
    
    private let persistentContainer: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    let backgroundContext: NSManagedObjectContext
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.persistentContainer.loadPersistentStores { _, error in
        }
        
        self.backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func createContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
}

extension CoreDataStack {
    func save(with context: NSManagedObjectContext, completion: ((Error?, Bool) -> Void)? = nil) {
        context.perform {
            guard context.hasChanges else {
                completion?(nil, false)
                return
            }
            do {
                try context.save()
                completion?(nil, true)
            } catch let error as NSError {
                print(error.localizedDescription)
                completion?(error, false)
            }
        }
    }
}
