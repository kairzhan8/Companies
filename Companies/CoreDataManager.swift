//
//  CoreDataManager.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/5/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistantContainer: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "CompaniesModels")
        container.loadPersistentStores { (storeDescriptoin, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
}
