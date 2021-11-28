//
//  CoreDataStack.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 23.11.21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var contextManager: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Error persistent container: \(error), description: \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        if contextManager.hasChanges {
            do {
                try contextManager.save()
            } catch let error as NSError {
                print("Error save context: \(error), description: \(error.userInfo)")
            }
        }
    }
}
