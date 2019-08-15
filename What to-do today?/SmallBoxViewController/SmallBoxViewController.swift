//
//  SmallBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/2.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData



class SmallBoxViewController: UIViewController {
    
    let walkthroughs = [
        WalkthroughModel(title: NSLocalizedString("Welcome!", comment: ""), subtitle: NSLocalizedString("With To-Doy, you can easily customize your to-do lists.", comment: ""), icon: "Tutorial(1)"),
        WalkthroughModel(title: NSLocalizedString("Add to-dos to today!", comment: ""), subtitle: NSLocalizedString("Add tasks to your daily to-do list", comment: ""), icon: "Tutorial(2)"),
        WalkthroughModel(title: NSLocalizedString("Clear done to-dos.", comment: ""), subtitle: NSLocalizedString("After you've checked off your finished tasks, tap the button in the upper right to clear them.", comment: ""), icon: "Tutorial(3)"),
        WalkthroughModel(title: NSLocalizedString("Postpone", comment: ""), subtitle: NSLocalizedString("If you decide to postpone a task, you can also move it off the Today list.", comment: ""), icon: "Tutorial(4)"),
        WalkthroughModel(title: NSLocalizedString("Achieve your goal!", comment: ""), subtitle: NSLocalizedString("Set your daily tasks at the start of each day. Stick to the tasks on the Today list and icrease productivity!", comment: ""), icon: "Tutorial(5)")
    ]
    
    // UI Components
    @IBOutlet weak var redBox: UIView!
    @IBOutlet weak var orangeBox: UIView!
    @IBOutlet weak var blueBox: UIView!
    @IBOutlet weak var greenBox: UIView!
    @IBOutlet weak var redTextView: UITextView!
    @IBOutlet weak var orangeTextView: UITextView!
    @IBOutlet weak var blueTextView: UITextView!
    @IBOutlet weak var greenTextView: UITextView!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var orangeLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    
    // Variables
    var user : User? = nil
    var mainList = [Todo]()
    var redList = [Todo]()
    var redIndexList = [Int]()
    var orangeList = [Todo]()
    var orangeIndexList = [Int]()
    var blueList = [Todo]()
    var blueIndexList = [Int]()
    var greenList = [Todo]()
    var greenIndexList = [Int]()
    var popUp : PopUpViewController? = nil
    var tempTodo = [Todo]()
    var categoriesList = [String]()
    var todayOrdersList = [String]()
    
    let UPPER_LEFT_COLOR : UIColor = #colorLiteral(red: 1, green: 0.5791445374, blue: 0.5924175978, alpha: 1)
    let UPPER_RIGHT_COLOR : UIColor = #colorLiteral(red: 1, green: 0.7859908342, blue: 0.5220321417, alpha: 1)
    let BOTTOM_LEFT_COLOR : UIColor = #colorLiteral(red: 0.768627451, green: 0.8431372549, blue: 0.9294117647, alpha: 1)
    let BOTTOM_RIGHT_COLOR : UIColor = #colorLiteral(red: 0.6162154078, green: 0.8536292911, blue: 0.6761775017, alpha: 1)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        redBox.layer.cornerRadius = 10
        orangeBox.layer.cornerRadius = 10
        blueBox.layer.cornerRadius = 10
        greenBox.layer.cornerRadius = 10
        redBox.backgroundColor = UPPER_LEFT_COLOR
        orangeBox.backgroundColor = UPPER_RIGHT_COLOR
        blueBox.backgroundColor = BOTTOM_LEFT_COLOR
        greenBox.backgroundColor = BOTTOM_RIGHT_COLOR
        
        // Data
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        do {
            var result = try PersistenceService.context.fetch(fetchRequest)
            print("There are \(result.count) user(s)")
            // No user profile is found
            if result.count == 0 { // []
                print("Creating initial user")
                let newUser = User(context: PersistenceService.context)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
                let walkthroughVC = self.walkthroughVC()
                walkthroughVC.delegate = self
                self.addChildViewControllerWithView(walkthroughVC)
                newUser.todoList = createTips()
                newUser.categoryList = [NSLocalizedString("Tips", comment: ""), NSLocalizedString("Untitled", comment: ""), NSLocalizedString("Untitled", comment: ""), NSLocalizedString("Untitled", comment: "") ]
                newUser.todayOrdersList = []
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        mainList = (user?.todoList)!
        categoriesList = (user?.categoryList)!
        todayOrdersList = (user?.todayOrdersList)!
        reload()
        reloadLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SmallBoxViewController.reload), name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editLabel), name: NSNotification.Name(rawValue: "reload label"), object: nil)
        
        // testing purpose
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        let walkthroughVC = self.walkthroughVC()
        walkthroughVC.delegate = self
        self.addChildViewControllerWithView(walkthroughVC)
    }
}
