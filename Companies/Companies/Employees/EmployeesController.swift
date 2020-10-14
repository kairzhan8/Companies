//
//  EmployeesController.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/12/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import CoreData

class IndendedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let rectangle = bounds.inset(by: padding)
        super.drawText(in: rectangle)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
    var company: Company?
    var employees: [Employee] = []
    
    var shortNameEmployees: [Employee] = []
    var longNameEmployees = [Employee]()
    var reallyLongNameEmployees = [Employee]()
    var allEmployees = [[Employee]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        print("Trying to fetch employees from core data")
        guard let employees = company?.employees?.allObjects as? [Employee] else { return }
        shortNameEmployees = employees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 5
            }
            return false
        })
        longNameEmployees = employees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count <= 8 && count >= 5
            }
            return false
        })
        
        reallyLongNameEmployees = employees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 8
            }
            return false
        })
        
        
        allEmployees = [shortNameEmployees, longNameEmployees, reallyLongNameEmployees]
//        self.employees = employees
//        let context = CoreDataManager.shared.persistantContainer.viewContext
//
//        let fetch = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do {
//            let employees = try context.fetch(fetch)
//            self.employees = employees
//        } catch let err {
//            print("Failed to fetch employees ", err)
//        }
    }
    
    let cellID = "cellllllid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        
        view.backgroundColor = .darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndendedLabel()
        label.backgroundColor = .lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkBlue
        if section == 0 {
            label.text = "Short name"
        } else if section == 1 {
            label.text = "Long name"
        } else {
            label.text = "Really long name"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
         
        let employee = allEmployees[indexPath.section][indexPath.row]
        cell.textLabel?.text = employee.name
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")     \(dateFormatter.string(from: birthday))"
        }
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "")      \(taxId)"
//        }
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    @objc private func handleAdd() {
        print("Trying to to add new employee")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .currentContext
        present(navController, animated: true, completion: nil)
    }
}
