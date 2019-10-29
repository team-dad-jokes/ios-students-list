//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let studentController = StudentController()
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //tableView.delegate = self
        
        studentController.loadFromPersistentStore(

            completion: { students, error in
            if let error = error {
                print("Error loading students: \(error)")
            }
            DispatchQueue.main.async {
                if let students = students {
                    
                    self.filteredAndSortedStudents = students
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    private func updateDataSource() {
        let filter = TrackType(rawValue: filterSelector.selectedSegmentIndex) ?? .none
        let sort = SortOptions(rawValue: sortSelector.selectedSegmentIndex) ?? .firstName
        
        studentController.filter(with: filter, sortedBy: sort, completion: {
            students in
            
            //DispatchQueue.main.async {
                self.filteredAndSortedStudents = students

            //}
        })
        
    }
    
    // MARK: - Private
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Student", for: indexPath)
        
        cell.textLabel?.text = filteredAndSortedStudents[indexPath.row].name
        cell.detailTextLabel?.text = filteredAndSortedStudents[indexPath.row].course
        
        return cell
    }
}
