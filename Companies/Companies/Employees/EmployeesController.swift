//
//  EmployeesController.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/12/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
    var company: Company?
    var employees: [Employee] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        print("Trying to fetch employees from core data")
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let fetch = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let employees = try context.fetch(fetch)
            self.employees = employees
        } catch let err {
            print("Failed to fetch employees ", err)
        }
    }
    
    let cellID = "cellllllid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        
        view.backgroundColor = .darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    @objc private func handleAdd() {
        print("Trying to to add new employee")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .currentContext
        present(navController, animated: true, completion: nil)
    }
}
