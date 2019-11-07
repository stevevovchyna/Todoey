//
//  ViewController.swift
//  Todoey
//
//  Created by Steve Vovchyna on 06.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
  
        let newItem = Item()
        newItem.title = "Kill Bill"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Rise a son"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Build a house"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
    }
    
    //MARK: - Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            
            if textFieldValue.text! == "" {
                newItem.title = "Empty to-do"
                self.itemArray.append(newItem)
            } else {
                newItem.title = textFieldValue.text!
                self.itemArray.append(newItem)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textFieldValue = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

