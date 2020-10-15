//
//  ViewController.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/3/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
            
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cell")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(handleDoNestedUpdates))
        ]
        
        setupNavigationStyle()
        
    }
    
    @objc private func handleDoNestedUpdates() {
        print("Trying to do nested updates")
        DispatchQueue.global(qos: .background).async {
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistantContainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "Kair \(company.name ?? "")"
                    do {
                        try privateContext.save()
                        DispatchQueue.main.async {
                            do {
                                let context = CoreDataManager.shared.persistantContainer.viewContext
                                if context.hasChanges {
                                    try context.save()
                                }
                            } catch let err {
                                print("Failed to save main context", err)
                            }
                            self.tableView.reloadData()
                        }
                    } catch let err {
                        print("Failed to save in privat context", err)
                    }
                }
            } catch let err {
                print("Failed to fetch from private context", err)
            }
        }
    }
    
    @objc private func handleDoUpdates() {
        print("Trying to updated works")
        CoreDataManager.shared.persistantContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "B: \(company.name ?? "")"
                }
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistantContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Failed ot save updates in background", err)
                }
            } catch let err {
                print("Failed to fetch in background", err)
            }
            
            
            
        }
    }
    
    @objc private func handleDoWork() {
        print("Trying to do...")
        CoreDataManager.shared.persistantContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Failed to save :", err)
                }
            }
        }
    }
    
    @objc private func handleReset() {
        print("Reset button was clicked")
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsForDelete = [IndexPath]()
            
            for (index, _ ) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsForDelete.append(indexPath)
            }
            
            companies.removeAll()
            tableView.deleteRows(at: indexPathsForDelete, with: .left)
        } catch let deleteErr {
            print("Failed to delete objects form Core Data", deleteErr)
        }
    }
    
    @objc private func handleAddCompany() {
        print("company added..")
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .currentContext
        
        present(navController, animated: true)
    }
}

