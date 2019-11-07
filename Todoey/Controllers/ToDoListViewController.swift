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
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        loadItems()
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
        self.saveListData()
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
                
                self.tableView.reloadData()
                
            } else {

                newItem.title = textFieldValue.text!

                self.itemArray.append(newItem)

                self.saveListData()
                
            }

        }
        
        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create new Item"

            textFieldValue = alertTextField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveListData() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            
            try data.write(to: dataFilePath!)

        } catch {

            print("Error encoding array: \(error)")

        }

        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
            
                itemArray = try decoder.decode([Item].self, from: data)

            } catch {

                print("Error decoding array: \(error)")
            
            }
        }
    }
}

