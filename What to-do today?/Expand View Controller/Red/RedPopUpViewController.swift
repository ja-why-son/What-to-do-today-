//
//  RedPopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

class RedPopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate {
    // UI Components
    @IBOutlet weak var expandRedBox: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var user : User? = nil
    var list = [Todo]()
    var expandingCellHeight: CGFloat = 200
    var expandingIndexRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Data
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        do {
            var result = try PersistenceService.context.fetch(fetchRequest)
            print("There are \(result.count) user(s)")
            print(result)
            // No user profile is found
            if result.count == 0 { // []
                print("Creating initial user")
                let newUser = User(context: PersistenceService.context)
                newUser.todoList = []
                // Todo(content: "First todo", category: "red", isToday: false)
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            
            print(result[0])
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        
        
        list = (user?.todoList)!
        for t in user!.todoList! {
            print(t.done)
        }
        
//        list.append(Todo(content: "schedule chipotle fundraiser", category: "red", isToday: false))
//        list.append(Todo(content: "fiuts cultural fest details make sure", category: "red", isToday: false))
        
        // Misc
        // Styling
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandRedBox.layer.cornerRadius = 15
        self.showAnimate()
        let offset = list.count == 0 ? 0 : 1
        expandingIndexRow = list.count - offset
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RedPopUpViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(RedPopUpViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
    }
    
    // TableView Data
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    @IBAction func checkCheckbox(_ sender : UIButton) {
        print(sender.tag)
        list[sender.tag].done = !list[sender.tag].done
        user?.todoList = []
        PersistenceService.saveContext() // Save newly created user
        
        user?.todoList = list
        PersistenceService.saveContext() // Save newly created user
        print("saved chekcbox")
        tableView.reloadData()
        
    }
    
    // Creating the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == list.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSection", for: indexPath) as! RedAddTableViewCell
            cell.expandCellDelegate = self
            cell.addRowDelegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tuple", for: indexPath) as! RedTupleTableViewCell
        cell.expandCellDelegate = self
        
        let currTodo = list[indexPath.row]
        cell.textView.text = currTodo.content
        cell.checkBox.tag = indexPath.row
        if !currTodo.done { cell.checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal) }
        else { cell.checkBox.setImage(UIImage(named: "checked_checkbox"), for: .normal) }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete item")
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todayAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Move to today")
            success(true)
        })
        todayAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [todayAction])
    }
    
    func updated(height: CGFloat) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        let indexPath = IndexPath(row: expandingIndexRow, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // implement here?
    }
    
    func addRow(_ sender:UITableViewCell, _ newContent:String) {
        list.append(Todo(content: newContent, category: "red", isToday: false))
        user?.todoList = list
        PersistenceService.saveContext() // Save newly created todo
        tableView.beginUpdates()
        let offset = list.count == 0 ? 0 : 1
        // if list.count == 0 -> offset = 0, else offset = 1
        tableView.insertRows(at: [IndexPath(row: list.count - offset, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func closeRedPopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    
    // Animation
    func showAnimate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        ToDoViewController().dataSource = nil
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: {(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
    

}
