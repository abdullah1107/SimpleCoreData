//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Muhammad Abdullah Al Mamun on 23/3/19.
//  Copyright © 2019 Muhammad Abdullah Al Mamun. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UITableViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        LoadItem_fromCoreDataModel()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Cell for Row Called!!")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text =  itemArray[indexPath.row].title
        
        let itemRow = itemArray[indexPath.row].done
        
        if itemRow == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let item = itemArray[indexPath.row]
        
        if item.done == false{
            itemArray[indexPath.row].done = true
        }
        else{
            itemArray[indexPath.row].done = false
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func plusButtonClicked(_ sender: UIBarButtonItem) {
        print("button clicked!!!")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add NewItem" , message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.SaveItem_ToCoreDataModel()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create NewItem"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func SaveItem_ToCoreDataModel(){
        do {
            try context.save()
        } catch  {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    
    func LoadItem_fromCoreDataModel(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print(error)
        }
    }
    
    
}
    



