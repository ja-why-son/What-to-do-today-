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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        redBox.layer.cornerRadius = 10
        orangeBox.layer.cornerRadius = 10
        blueBox.layer.cornerRadius = 10
        greenBox.layer.cornerRadius = 10
        
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
                newUser.categoryList = ["Red", "Orange", "Blue", "Green" ]
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
                redText = redText + "-" + mainList[i].content! + "\n"
            case "orange":
                // do orange
                orangeList.append(mainList[i])
                orangeIndexList.append(i)
                orangeText = orangeText + "-" + mainList[i].content! + "\n"
            case "blue":
                // do blue
                blueList.append(mainList[i])
                blueIndexList.append(i)
                blueText = blueText + "-" + mainList[i].content! + "\n"
            case "green":
                // do green
                greenList.append(mainList[i])
                greenIndexList.append(i)
                greenText = greenText + "-" + mainList[i].content! + "\n"
            default: break
            }
        }
        redTextView.text = redText
        orangeTextView.text = orangeText
        blueTextView.text = blueText
        greenTextView.text = greenText
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
                popUp?.color = #colorLiteral(red: 1, green: 0.5960784314, blue: 0.6941176471, alpha: 1)
                popUp?.list = redList
                popUp?.indexList = redIndexList
                popUp?.category = "red"
                popUp?.categoryName = categoriesList[0]
            case 1:  // do orange
                popUp?.color = #colorLiteral(red: 1, green: 0.7859908342, blue: 0.5220321417, alpha: 1)
                popUp?.list = orangeList
                popUp?.indexList = orangeIndexList
                popUp?.category = "orange"
                popUp?.categoryName = categoriesList[1]
            case 2:  // do blue
                popUp?.color = #colorLiteral(red: 0.5487036109, green: 0.8750793338, blue: 1, alpha: 1)
                popUp?.list = blueList
                popUp?.indexList = blueIndexList
                popUp?.category = "blue"
                popUp?.categoryName = categoriesList[2]
            case 3:  // do green
                popUp?.color = #colorLiteral(red: 0.5415468216, green: 1, blue: 0.6116992235, alpha: 1)
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
    // SETTING METHOD & DEBUGGING METHOD
    
    @IBAction func eraseData(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Data", message: "Data Cleared", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        user?.todoList =  []
        mainList = []
        PersistenceService.saveContext()
        reload()
        
    }
    
    @IBAction func clearDone(_ sender: Any) {
        
        tempTodo = []
        for i in stride(from: 0, to: mainList.count, by: 1) {
            if !mainList[i].done {
                tempTodo.append(mainList[i])
            }
        }
        user?.todoList = []
        PersistenceService.saveContext()
        user?.todoList = tempTodo
        PersistenceService.saveContext()
        reload()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
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
        user?.todoList = []
        PersistenceService.saveContext() // Save newly created user
        user?.todoList = mainList
        PersistenceService.saveContext() // Save newly created user
        reload()
    }
    
    func moveTodayOrOut(ogIndex index : Int) {
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
