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
    
    func fetchCompanies() -> [Company] {
        let context = persistantContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies =  try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies", fetchErr)
            return []
        }
    }
}
