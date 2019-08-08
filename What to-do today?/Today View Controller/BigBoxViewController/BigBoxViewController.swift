//
//  BigBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

class BigBoxViewController: UIViewController{
    
    
    // UI Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayBox: UIView!
    @IBOutlet weak var clearDoneButton: UIButton!
    
    // Variables
    var user : User? = nil
    var list = [Todo]()
    var ordersList = [String]() 
    var todayList = [Todo]()
    var todayIndexList = [Int]()
    var expandingCellHeight: CGFloat = 200
    var expandingIndexRow: Int = 0
    var todayIsEditting : Bool = false
    var todayOrdersList = [String]()
    var todayDict : [String? : Todo] = [:]

    
    
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
//                let newUser = User(context: PersistenceService.context)
//                newUser.categoryList = ["Get started!", "Where's \"Today\"?", "With To-Doy...", "Enjoy!" ]
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        list = (user?.todoList)!
        todayOrdersList = (user?.todayOrdersList)!
        reloadToday() // first time classifying
//        checkDoneExist()
        
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
        loadTodayTodoToDict()
        print(todayDict)
    }
}
