//
//  SmallBoxViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/2.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

protocol SmallBoxPopUpDelegate {
    func appendTodo(_ newTodo : Todo) -> Int
    func editContent (_ newText : String, ogIndex index : Int)
    func checkBox(ogIndex index : Int)
    func moveTodayOrOut(ogIndex index : Int)
    func deleteTodo(ogIndex index : Int, _ category : String) -> [Int]
}


class SmallBoxViewController: UIViewController, SmallBoxPopUpDelegate {
    
    // UI Components
    @IBOutlet weak var redBox: UIView!
    @IBOutlet weak var orangeBox: UIView!
    @IBOutlet weak var blueBox: UIView!
    @IBOutlet weak var greenBox: UIView!
    @IBOutlet weak var erasebutton: UIButton!
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
    let BOTTOM_LEFT_COLOR : UIColor = #colorLiteral(red: 1, green: 0.9304491878, blue: 0.6437133551, alpha: 1)
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
                newUser.todoList = createInstruction()
                newUser.categoryList = ["Get started!", "Where's \"Today\"?", "With To-Doy...", "Enjoy!" ]
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        mainList = (user?.todoList)!
        categoriesList = (user?.categoryList)!
        
        
        // load the interface information
        reload() // classify for the first time
        reloadLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SmallBoxViewController.reload), name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.editLabel), name: NSNotification.Name(rawValue: "reload label"), object: nil)
    }
    
    func createInstruction() -> [Todo] {
        let upperLeft = [Todo(content: "Jot down your tasks here", category: "red", isToday: false),
                          Todo(content: "Check them off when you're done", category: "red", isToday: false),
                          Todo(content: "Swipe RIGHT to add to \"Today\" page", category: "red", isToday: false),
                          Todo(content: "Swipe LEFT to elete todo", category: "red", isToday: false),
                            Todo(content: "Tap the title to edit", category: "red", isToday: false)];
        let upperRight = [Todo(content: "Exit this box and swipe LEFT to get to \"Today\" page", category: "orange", isToday: false),
                          Todo(content: "Exit the box and swipe left to TODAY", category: "orange", isToday: false),
                          Todo(content: "All the todos you should finish today are over there!", category: "orange", isToday: false)]
        let bottomLeft = [Todo(content: "Plan out your tasks today", category: "blue", isToday: false),
                          Todo(content: "Organize your to-do lists", category: "blue", isToday: false)]
        let bottomRight = [Todo(content: "If you like this app, make sure to rate us on the app store", category: "green", isToday: false),Todo(content: "Happy productivity!", category: "green", isToday: false)]
        let today = [Todo(content: "Finish these tasks today", category: "none", isToday: true),
                     Todo(content: "Tap \"New Day\" to clear your checked taks", category: "none", isToday: true),
                     Todo(content: "Swipe RIGHT to get back to home boxes", category: "none", isToday: true)]
        return today + upperLeft + upperRight + bottomLeft + bottomRight
    }
    
    @objc func editLabel(_ notification : NSNotification) {
        if let userInfo = notification.userInfo as? [String : Int] {
            print(userInfo)
            let newLabelName = Array(userInfo.keys)[0]
            let labelCategory = Array(userInfo.values)[0]
            print(newLabelName)
            print(labelCategory)
            categoriesList[labelCategory] = newLabelName
            user?.categoryList = []
            PersistenceService.saveContext()
            user?.categoryList = categoriesList
            PersistenceService.saveContext()
            reloadLabel()
        }
    }
    
    func reloadLabel () {
        redLabel.text = categoriesList[0]
        orangeLabel.text = categoriesList[1]
        blueLabel.text = categoriesList[2]
        greenLabel.text = categoriesList[3]
    }
    
    // CLASSIFY THE WHOLE LIST INTO CATEGORIES
    // ALSO USED DURING RELOAD
    @objc func reload () {
        mainList = (user?.todoList)!
        categoriesList = (user?.categoryList)!
        redList = []
        orangeList = []
        blueList = []
        greenList = []
        redIndexList = []
        orangeIndexList = []
        blueIndexList = []
        greenIndexList = []
        var redText : String = ""
        var orangeText : String = ""
        var blueText : String = ""
        var greenText : String = ""
        for i in stride(from: 0, to: mainList.count, by: 1) {
            switch mainList[i].category {
            case "red":
                // do red
                redList.append(mainList[i])
                redIndexList.append(i)
                redText = redText +  mainList[i].content! + "\n"
            case "orange":
                // do orange
                orangeList.append(mainList[i])
                orangeIndexList.append(i)
                orangeText = orangeText + mainList[i].content! + "\n"
            case "blue":
                // do blue
                blueList.append(mainList[i])
                blueIndexList.append(i)
                blueText = blueText + mainList[i].content! + "\n"
            case "green":
                // do green
                greenList.append(mainList[i])
                greenIndexList.append(i)
                greenText = greenText + mainList[i].content! + "\n"
            case "none":
                print()
            default: return
            }
        }
        redTextView.text = redText
        redTextView.contentOffset = .zero
        orangeTextView.text = orangeText
        orangeTextView.contentOffset = .zero
        blueTextView.text = blueText
        blueTextView.contentOffset = .zero
        greenTextView.text = greenText
        greenTextView.contentOffset = .zero
//        print("the textview size");
//        print(redTextView.contentSize);
//        let ex = "- abcdefghijklmnopqrst"
//        let hi = "- support both languages"
//        let oneCh = "a"
//        let size = ex.size(withAttributes: [.font: redTextView.font!])
//        let size2 = oneCh.size(withAttributes: [.font: redTextView.font!])
//        print("size of one character is \(size2)");
//        print("size of text is \(size)");
    }
    
    
    // OPEN EACH OF THE POPUP
    @IBAction func showBox (_ sender :  Any) {
//        print(sender)
        var senderTag : Int = -1
        
//        print(type(of: sender))
        let gesture = sender as? UITapGestureRecognizer
        //print(gesture?.view?.tag)
        senderTag = (gesture?.view!.tag)!
        
        popUp = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController)
        popUp?.user = user
//        popUp?.label.tag = senderTag
        popUp?.labelTag = senderTag
        
        switch senderTag {
            case 0: // do red
                popUp?.color = UPPER_LEFT_COLOR
                popUp?.list = redList
                popUp?.indexList = redIndexList
                popUp?.category = "red"
                popUp?.categoryName = categoriesList[0]
            case 1:  // do orange
                popUp?.color = UPPER_RIGHT_COLOR
                popUp?.list = orangeList
                popUp?.indexList = orangeIndexList
                popUp?.category = "orange"
                popUp?.categoryName = categoriesList[1]
            case 2:  // do blue
                popUp?.color = BOTTOM_LEFT_COLOR
                popUp?.list = blueList
                popUp?.indexList = blueIndexList
                popUp?.category = "blue"
                popUp?.categoryName = categoriesList[2]
            case 3:  // do green
                popUp?.color = BOTTOM_RIGHT_COLOR
                popUp?.list = greenList
                popUp?.indexList = greenIndexList
                popUp?.category = "green"
                popUp?.categoryName = categoriesList[3]
            default: return // do last one
        }
        self.addChild(popUp!)
        popUp!.view.frame = self.view.frame
        self.view.addSubview(popUp!.view)
        popUp!.didMove(toParent: self)
        popUp!.delegate = self
    }
    
    
    /**********************************************************************************************************/
    // DELEGATE METHOD BETWEEN SMALL BOX AND POP UP
    // CORE DATA USING METHOD
    
    func appendTodo (_ newTodo : Todo) -> Int{
        mainList.append(newTodo)
        user?.todoList = mainList
        PersistenceService.saveContext()
        reload() // re-classify
        return mainList.count - 1
    }
    
    func editContent (_ newText : String, ogIndex index : Int) {
        // change main data
        mainList[index].content = newText
        user?.todoList = []
        PersistenceService.saveContext()
        user?.todoList = mainList
        PersistenceService.saveContext()
        reload()
    }
    
    // PROBLEM HERE TO BE FIXED!!
    func checkBox(ogIndex index : Int) {
        mainList = (user?.todoList)!
        user?.todoList = []
        PersistenceService.saveContext() // Save newly created user
        user?.todoList = mainList
        PersistenceService.saveContext() // Save newly created user
        reload()
    }
    
    func moveTodayOrOut(ogIndex index : Int) {
        mainList = (user?.todoList)!
        user?.todoList = []
        PersistenceService.saveContext() // Save newly created user
        user?.todoList = mainList
        PersistenceService.saveContext() // Save newly created user
        reload()
    }
    
    func deleteTodo(ogIndex index : Int, _ category : String) -> [Int] {
        mainList.remove(at: index)
        user?.todoList = mainList
        PersistenceService.saveContext()
        reload()
        switch category {
        case "red" : return redIndexList
        case "orange" : return orangeIndexList
        case "blue" : return blueIndexList
        case "green" : return greenIndexList
        default : return [0]
        }
    }
}
