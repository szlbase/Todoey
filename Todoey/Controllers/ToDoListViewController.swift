//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var items : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            getItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItems()
        
        tableView.rowHeight = 80
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavBar(color: selectedCategory?.backgroundColor)
        setUpSearchBar(color: selectedCategory?.backgroundColor)
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item  = items?[indexPath.row], let itemCount = items?.count, let itemColor = selectedCategory?.backgroundColor {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let backgroundColor = UIColor(hexString: itemColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemCount + 5)){
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: false)
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
//                    realm.delete(item)
                })
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: Constants.cellItems.addNewToDo, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.cellItems.addItem, style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch {
                print(error)
            }
        }
    }
    
    fileprivate func setUpNavBar(color: String?) {
        if let color = color, let backgroundColor = UIColor(hexString: color) {
            
            guard let navBar = navigationController?.navigationBar else { return }
            
            let backgroundContrastColor = ContrastColorOf(backgroundColor, returnFlat: true)
            
            //For small title
            navBar.barTintColor = backgroundColor
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: backgroundContrastColor]
            
            //For large title
            navBar.backgroundColor = backgroundColor
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: backgroundContrastColor]
            
            //For back button and Add icon
            navBar.tintColor = backgroundContrastColor
            
            title = selectedCategory!.name
            
        }
    }
    
    fileprivate func setUpSearchBar(color: String?) {
        if let color = color, let backgroundColor = UIColor(hexString: color) {
            searchBar.barTintColor = backgroundColor
            searchBar.searchTextField.backgroundColor = UIColor.flatWhite()
        }
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}

//MARK: Request related
extension ToDoListViewController {
    
    func getItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        items = realm.objects(Item.self)
        tableView.reloadData()
    }
}
