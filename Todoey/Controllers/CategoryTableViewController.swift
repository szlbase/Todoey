//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by LIN SHI ZHENG on 21/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        setUpNavBar()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: Constants.cellItems.addNewCategory, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.cellItems.addCategory, style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category  = categories?[indexPath.row], let backgroundColor = category.backgroundColor {
            
            cell.backgroundColor = UIColor(hexString: backgroundColor)
            
            cell.textLabel?.text = category.name
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.segue.goToItemsSeque, sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(category)
                })
            } catch {
                print(error)
            }
        }
    }
    
    fileprivate func setUpNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let backgroundColor = UIColor.flatBlue()
        let backgroundContrastColor = ContrastColorOf(UIColor.flatBlue(), returnFlat: true)
        
        //For small title
        navBar.barTintColor = backgroundColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: backgroundContrastColor]
        
        //For large title
        navBar.backgroundColor = backgroundColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: backgroundContrastColor]
        
        //For back button and Add icon
        navBar.tintColor = backgroundContrastColor
    }
}

//MARK: Data manipulation methods
extension CategoryTableViewController {
    
    func save(category: Category) {
        
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    
    func getCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
