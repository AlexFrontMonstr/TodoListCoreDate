//
//  TableViewController.swift
//  toDoListCoreData
//
//  Created by Александр Полетаев on 13.11.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Tasks] = []
    
    @IBAction func deleteTask(_ sender: UIBarButtonItem) {
        
        self.tasks.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        if let tasks = try? contex.fetch(fetchRequest) {
            for task in tasks {
                contex.delete(task)
            }
        }
        
        do {
            try contex.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    @IBAction func addTasks(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Task", message: "Create a task", preferredStyle: .alert)
        let saveTask = UIAlertAction(title: "Save", style: .default) { action in
            let textFeild = alertController.textFields?.first
            if let newTask = textFeild?.text{
                self.saveTask(withTask: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alertController.addAction(saveTask)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveTask(withTask title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: contex) else {
            return
            
        }
        let taskObject = Tasks(entity: entity, insertInto: contex)
        taskObject.title = title
        
        do {
            try contex.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try contex.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    
    
}
