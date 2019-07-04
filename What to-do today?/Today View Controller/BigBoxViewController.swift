//
//  BigBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

class BigBoxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, TableCellTodoTodayBoxDelegate{
    
    
    // UI Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayBox: UIView!
    
    // Variables
    var user : User? = nil
    var list = [Todo]()
    var todayList = [Todo]()
    var todayIndexList = [Int]()
    var expandingCellHeight: CGFloat = 200
    var expandingIndexRow: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        do {
            var result = try PersistenceService.context.fetch(fetchRequest)
            print("There are \(result.count) user(s)")
            // No user profile is found
            if result.count == 0 { // []
                print("Creating initial user")
                let newUser = User(context: PersistenceService.context)
                newUser.todoList = []
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        list = (user?.todoList)!
        reloadToday() // first time classifying
        
        // Layout setting
        todayBox.layer.cornerRadius = 10
        
        // Misc things
        let offset = todayList.count == 0 ? 0 : 1
        expandingIndexRow = todayList.count - offset
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(BigBoxViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(BigBoxViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(BigBoxViewController.reloadToday),
            name:NSNotification.Name(rawValue: "reloadToday"),
            object: nil)
        
    }
    
    // call everytime when popup modification method is called
    @objc func reloadToday() {
        list = (user?.todoList)!
        todayList = []
        todayIndexList = []
        for i in stride(from: 0, to: list.count, by: 1) {
            if list[i].isToday {
                todayList.append(list[i])
                todayIndexList.append(i)
            }
        }
        tableView.reloadData()
//        print("Total count \(todayList.count)")
    }
    
    /**********************************************************************************************************/
    // table view presentation
    //
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayList.count
    }
    
    // this method is called multiple times whenever a certain indexPath is asking for a data, therefore, assign "" for index 'list.count'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tuple", for: indexPath) as! TodayTupleTableViewCell
        cell.expandCellDelegate = self
        cell.tableCellTodoTodayBoxDelegate = self
        let currTodo = todayList[indexPath.row]
        cell.textView.text = currTodo.content
        cell.checkBox.tag = indexPath.row
        if currTodo.done! == false {
            cell.checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checked_checkbox"), for: .normal)
        }
        return cell
    }
    /**********************************************************************************************************/
    // keyboard configuration
    //
    //
    //
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification);
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification);
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableView.estimatedRowHeight, right: 0) // if there's a problem think about using the frame and content size
            tableView.scrollIndicatorInsets = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        let tableRect = tableView.rect(forSection: 0)
        tableView.scrollRectToVisible(tableRect, animated: true)
    }
    
    /**********************************************************************************************************/
    // customized method
    
    func updated() {
        // expandingCellHeight = height
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    /**********************************************************************************************************/
    // USE CORE DATA
    //
    // Check the checkbox
    @IBAction func checkCheckBox(_ sender: UIButton) {
        let index = sender.tag
        list[todayIndexList[index]].done! = !list[todayIndexList[index]].done!
        user?.todoList! = []
        PersistenceService.saveContext()
        user?.todoList! = list
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    // edit the text in the today box
    func doneEdittingTodayCell(_ newText: String, _ sender : TodayTupleTableViewCell) {
        let index = tableView.indexPath(for: sender)?.row
        list[todayIndexList[index!]].content = newText
        user?.todoList! = []
        PersistenceService.saveContext()
        user?.todoList! = list
        PersistenceService.saveContext()
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
    }
    
}
