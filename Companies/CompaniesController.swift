//
//  ViewController.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/3/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    var companies = [Company]()
    
//    var companies = [
//        Company(name: "Apple", founded: Date()),
//        Company(name: "Google", founded: Date()),
//        Company(name: "Facebook", founded: Date())
//
//    ]
    
    private func fetchCompanies() {
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
           let companies =  try context.fetch(fetchRequest)
            
            companies.forEach { (company) in
                print(company.name ?? "")
                
                self.companies = companies
            }
        } catch let fetchErr {
            print("Failed to fetch companies", fetchErr)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
//        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupNavigationStyle()
        
    }
    
    @objc func handleAddCompany() {
        print("company added..")
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .currentContext
        createCompanyController.delegate = self
        
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        
        cell.backgroundColor = .tealColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let company = self.companies[indexPath.row]
            
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let context = CoreDataManager.shared.persistantContainer.viewContext
            
            context.delete(company)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Error when deleteing company", saveErr)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            print("Trying to edit")
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        
        return swipeActions
    }

}

