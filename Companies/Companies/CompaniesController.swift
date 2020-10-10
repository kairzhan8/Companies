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
    func didEditCompany(company: Company) {
        guard let row = companies.firstIndex(of: company) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
        
    }
    
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
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        setupNavigationStyle()
        
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
//            companies.removeAll()
//            tableView.reloadData()
        } catch let deleteErr {
            print("Failed to delete objects form Core Data", deleteErr)
        }
    }
    
    @objc func handleAddCompany() {
        print("company added..")
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .currentContext
        createCompanyController.delegate = self
        
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.attributedText = NSAttributedString(string: "No companies available", attributes:
        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyCell
        
        let company = companies[indexPath.row]
        cell.company = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
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
            self.editHandlerFunction(indexPath: indexPath)
        }
        
        deleteAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
    
    private func editHandlerFunction(indexPath: IndexPath) {
        
        print("Trying to edit")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        navController.modalPresentationStyle = .currentContext
        present(navController, animated: true, completion: nil)
    }

}

