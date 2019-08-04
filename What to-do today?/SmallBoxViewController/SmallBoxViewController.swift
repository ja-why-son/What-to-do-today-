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
        WalkthroughModel(title: "Quick Overview", subtitle: "Quickly visualize important business metrics. The overview in the home tab shows the most important metrics to monitor how your business is doing in real time.", icon: "analytics-icon"),
        WalkthroughModel(title: "Analytics", subtitle: "Dive deep into charts to extract valuable insights and come up with data driven product initiatives, to boost the success of your business.", icon: "bars-icon"),
        WalkthroughModel(title: "Dashboard Feeds", subtitle: "View your sales feed, orders, customers, products and employees.", icon: "activity-feed-icon"),
        WalkthroughModel(title: "Get Notified", subtitle: "Receive notifications when critical situations occur to stay on top of everything important.", icon: "bell-icon"),
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
                // load the instruction below
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
                let walkthroughVC = self.walkthroughVC()
                walkthroughVC.delegate = self
                self.addChildViewControllerWithView(walkthroughVC)
                newUser.todoList = createInstruction()
                newUser.categoryList = ["Get started!", "\"Today\"?", "With To-Doy...", "Enjoy!" ]
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        mainList = (user?.todoList)!
        categoriesList = (user?.categoryList)!
        reload()
        reloadLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SmallBoxViewController.reload), name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editLabel), name: NSNotification.Name(rawValue: "reload label"), object: nil)
    }
}
