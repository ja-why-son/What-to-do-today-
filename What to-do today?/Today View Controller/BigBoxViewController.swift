//
//  BigBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

class BigBoxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate {
    
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
        expandingIndexRow = list.count - 1
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
    }
    
    func reloadToday() {
        list = (user?.todoList)!
        todayList = []
        todayIndexList = []
        for i in stride(from: 0, to: list.count, by: 1) {
            if list[i].isToday {
                todayList.append(list[i])
                todayIndexList.append(i)
            }
        }
        print("Total count \(todayList.count)")
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayList.count + 1
    }
    
    // this method is called multiple times whenever a certain indexPath is asking for a data, therefore, assign "" for index 'list.count'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == todayList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSection", for: indexPath) as!TodayAddTableViewCell
            cell.expandCellDelegate = self
            cell.addRowDelegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tuple", for: indexPath) as! TodayTupleTableViewCell
        cell.expandCellDelegate = self
        print(indexPath.row)
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
//        guard let userInfo = notification.userInfo else {return}
//        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
//        let keyBoardFrame = keyboardSize.cgRectValue
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= keyBoardFrame.height
//        }
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y -= 0
//        }
    }
    
    /**********************************************************************************************************/
    // customized method
    
    func updated(height: CGFloat) {
        // expandingCellHeight = height
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
    func addRow(_ sender:UITableViewCell, _ newString:String) {
//        list.append(newString)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: list.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
}
