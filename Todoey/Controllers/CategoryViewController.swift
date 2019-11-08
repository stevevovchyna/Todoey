//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Steve Vovchyna on 08.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Categoria]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldValue = UITextField()
        let emptyCategoryNameAlert = UIAlertController(title: "Empty Input", message: "Please enter some text", preferredStyle: .alert)
        let emptyCategoryAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            emptyCategoryNameAlert.dismiss(animated: true, completion: nil)
        }
        
        emptyCategoryNameAlert.addAction(emptyCategoryAlertAction)
        
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let range = NSRange(location: 0, length: textFieldValue.text!.utf16.count)
            let regex = try! NSRegularExpression(pattern: #"^\s*$"#)
            if regex.firstMatch(in: textFieldValue.text!, options: [], range: range) != nil {
                self.present(emptyCategoryNameAlert, animated: true, completion: nil)
            } else {
                let newItem = Categoria(context: self.context)
                newItem.name = textFieldValue.text!
                self.categoryArray.append(newItem)
                self.saveListData()
            }
        }
        
        let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textFieldValue = alertTextField
        }
         
        alert.addAction(action)
        alert.addAction(dismissAlert)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveListData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Categoria> = Categoria.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }

}
