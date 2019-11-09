//
//  ViewController.swift
//  Todoey
//
//  Created by Steve Vovchyna on 06.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var listTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navbar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist") }
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        title = selectedCategory!.name
        
        guard let currentColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex), isFlat: true) else { fatalError() }
        
        guard let navBarColor = UIColor(hexString: colorHex) else { fatalError() }
        navbar.barTintColor = navBarColor
                
        tableView.backgroundColor = navBarColor
                
        listTitle.rightBarButtonItem?.tintColor = currentColor

        navbar.tintColor = currentColor
                
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : currentColor]
        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : currentColor]
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let currentColor = selectedCategory?.color {
                if let color = UIColor(hexString: currentColor).darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)) / 6.5) {
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
                    cell.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
                }
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating data: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldValue = UITextField()
        let emptyTodoAlert = UIAlertController(title: "Empty Input", message: "Please enter some text", preferredStyle: .alert)
        let emptyTodoAlertAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            emptyTodoAlert.dismiss(animated: true, completion: nil)
        }
        
        emptyTodoAlert.addAction(emptyTodoAlertAction)
        
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let range = NSRange(location: 0, length: textFieldValue.text!.utf16.count)
            let regex = try! NSRegularExpression(pattern: #"^\s*$"#)
            if regex.firstMatch(in: textFieldValue.text!, options: [], range: range) != nil {
                self.present(emptyTodoAlert, animated: true, completion: nil)
            } else {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textFieldValue.text!
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving data: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textFieldValue = alertTextField
        }
         
        alert.addAction(action)
        alert.addAction(dismissAlert)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
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
//
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
