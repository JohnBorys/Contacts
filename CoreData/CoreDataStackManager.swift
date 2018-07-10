//
//  CoreDataStackManager.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 19.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import CoreData

class CoreDataStackManager: NSObject {
    
    let modelName = "Contacts"
    
    let persistentContainer = NSPersistentContainer(name: "Contacts")
    
    override init() {
        let group = DispatchGroup()
        
        group.enter()
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            print("Core Data stack has been initialized with description: \(storeDescription)")
            
            group.leave()
        }
        
        group.wait()
    }
    
    func saveMoc() {
        do {
            try DataManager.coreDataStackManager.persistentContainer.viewContext.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
}

