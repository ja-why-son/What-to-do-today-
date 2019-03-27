//
//  PopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

class PopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate, tableCellTodoDelegate {
    
    // UI Components
    @IBOutlet weak var expandBox: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var user : User? = nil
    var list = [Todo]()
    var indexList = [Int]()
    var expandingCellHeight: CGFloat = 200
    var expandingIndexRow: Int = 0
    var color : UIColor? = nil
    var category : String? = nil
    var delegate : SmallBoxPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Styling
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandBox.layer.cornerRadius = 15
        expandBox.backgroundColor = color
        self.showAnimate()
        let offset = list.count == 0 ? 0 : 1
        expandingIndexRow = list.count - offset
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        //Misc
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PopUpViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(PopUpViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
//        list.append(Todo(content: "schedule chipotle fundraiser", category: "red", isToday: false))
//        list.append(Todo(content: "fiuts cultural fest details make sure", category: "red", isToday: false))
        
        
    }
    
    /**********************************************************************************************************/
    // Show and close animation
    // Animation
    //
    //
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
    
    @IBAction func closeRedPopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    /**********************************************************************************************************/
    // table view presentation
    //
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
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
        cell.tableCellTodoDelegate = self
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
    
    /**********************************************************************************************************/
    // keyboard configuration
    //
    //
    //
    @objc func keyboardWillShow(notification: NSNotification) {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // implement here?
    }
    
    /**********************************************************************************************************/
    // customized method
    
    func updated(height: CGFloat) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        let indexPath = IndexPath(row: expandingIndexRow, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    /**********************************************************************************************************/
    // USE CORE DATA
    //
    //
    
    // APPEND NEW ROW
    // make append delegate method return the list.count
    func addRow(_ sender:UITableViewCell, _ newContent:String) {
        let newTodo = Todo(content: newContent, category: self.category!, isToday: false)
        self.list.append(newTodo)
        let newIndex = delegate?.appendTodo(newTodo)
        self.indexList.append(newIndex!)
        print(indexList)
        tableView.beginUpdates()
        let offset = list.count == 0 ? 0 : 1
        // if list.count == 0 -> offset = 0, else offset = 1
        tableView.insertRows(at: [IndexPath(row: list.count - offset, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    // DONE OR NOT DONE
    // TBF
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
    
    // EDIT CONTENT
    // Send the new text and the original index back to small box view controller to edit the main data
    // also edit local(popup) list
    func doneEditting(_ newText : String, _ sender : RedTupleTableViewCell) {
        let index = tableView.indexPath(for: sender)![1]
        print(index)
        list[index].content = newText
        print(indexList[index])
        delegate?.editContent(newText, ogIndex: indexList[index])
    }
    
    

}
