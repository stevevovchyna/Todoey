//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Steve Vovchyna on 08.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
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
                let newCategory = Category()
                newCategory.name = textFieldValue.text!
                self.save(category: newCategory)
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
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - delete datat from the table
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

}

