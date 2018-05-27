//
//  SecondViewController.swift
//  Projekt
//
//  Created by Beata Wikło on 26.05.2018.
//  Copyright © 2018 Pawel Wiklo Katarzyna Chardy. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UITableViewController
{
    var name:String = ""
    var name2:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//         self.title = "Lista Zakupow"
        self.title = name
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SecondViewController.didTapAddItemButton(_:)))
        
        
        
        //load data
        // Setup a notification to let us know when the app is about to close,
        // and that we should store the user items to persistence. This will call the
        // applicationDidEnterBackground() function in this class
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        do
        {
            // Try to load from persistence
            self.todoItems2 = try [ToDoItem2].readFromPersistence2(name: name)
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                NSLog("No persistence file found, not necesserially an error...")
            }
            else
            {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load the to-do items!",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                NSLog("Error loading from persistence: \(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //private var todoItems2 = ToDoItem2.getMockData()
    private var todoItems2 = [ToDoItem2]()
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todoItems2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.deselectRow(at: indexPath, animated: true)
        //print([indexPath.row])
        let cell2 = self.tableView.cellForRow(at: indexPath)
        let cell3 = cell2?.textLabel?.text
        if cell3 != nil
        {
            print([cell3]) //wypisuje nazwe
            name2 = cell3!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo2", for: indexPath)
         let button = cell.viewWithTag(100) as! UIButton
        if indexPath.row < todoItems2.count
        {
            let item = todoItems2[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
            
            button.setTitle(cell3, for: .normal)
        }
       
        
        //

        
        //
        //name2 = cell3!
        //button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.setTitle(cell3, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        
        
        return cell
    }
    @objc public func buttonClicked(_ sender:UIButton) {
        //print(name2)
        //print("info clicked", name2)
        //print(sender.currentTitle)
        
        // Create an alert
        let alert = UIAlertController(
            title: sender.currentTitle,
            message: "",
            preferredStyle: .alert)

        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < todoItems2.count
        {
            let item = todoItems2[indexPath.row]
            item.done = !item.done
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func didTapAddItemButton(_ sender: UIBarButtonItem)
    {
        // Create an alert
        let alert = UIAlertController(
            title: "Nowy przedmiot",
            message: "Podaj nowy przedmiot do kupienia",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField(configurationHandler: nil)
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text
            {
                self.addNewToDoItem(title: title)
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addNewToDoItem(title: String)
    {
        // The index of the new item will be the current item count
        let newIndex = todoItems2.count
        
        // Create new item and add it to the todo items list
        todoItems2.append(ToDoItem2(title: title))
        
        // Tell the table view a new row has been created
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < todoItems2.count
        {
            todoItems2.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        do
        {
            try todoItems2.writeToPersistence2(name: name)
        }
        catch let error
        {
            NSLog("Error writing to persistence: \(error)")
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("Back pressed")
            do
            {
                try todoItems2.writeToPersistence2(name: name)
            }
            catch let error
            {
                NSLog("Error writing to persistence: \(error)")
            }
        }
    }
    
}
