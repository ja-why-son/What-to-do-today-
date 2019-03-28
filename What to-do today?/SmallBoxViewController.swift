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
}

class SmallBoxViewController: UIViewController, SmallBoxPopUpDelegate {
    
    // UI Components
    @IBOutlet weak var redBox: UIView!
    @IBOutlet weak var orangeBox: UIView!
    @IBOutlet weak var blueBox: UIView!
    @IBOutlet weak var greenBox: UIView!
    @IBOutlet weak var erasebutton: UIButton!
    
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
//            print("There are \(result.count) user(s)")
//            print(result)
            // No user profile is found
            if result.count == 0 { // []
//                print("Creating initial user")
                let newUser = User(context: PersistenceService.context)
                newUser.todoList = []
                // Todo(content: "First todo", category: "red", isToday: false)
                PersistenceService.saveContext() // Save newly created user
                result = try PersistenceService.context.fetch(fetchRequest) // Fetch the CoreData again with the new user
            }
            
//            print(result[0])
            user = result[0]
        } catch {
            print("FATAL: Couldn't fetch Coredata")
        }
        mainList = (user?.todoList)!
        classify()
    }
    
    // CLASSIFY THE WHOLE LIST INTO CATEGORIES
    // ALSO USED DURING RELOAD
    func classify () {
        redList = []
        orangeList = []
        blueList = []
        greenList = []
        redIndexList = []
        orangeIndexList = []
        blueIndexList = []
        greenIndexList = []
        for i in stride(from: 0, to: mainList.count, by: 1) {
            switch mainList[i].category {
            case "red":
                // do red
                redList.append(mainList[i])
                redIndexList.append(i)
            case "orange":
                // do orange
                orangeList.append(mainList[i])
                orangeIndexList.append(i)
            case "blue":
                // do blue
                blueList.append(mainList[i])
                blueIndexList.append(i)
            case "green":
                // do green
                greenList.append(mainList[i])
                greenIndexList.append(i)
            default:
                print("error")
            }
        }
        mainList = (user?.todoList)!
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
        
        switch senderTag {
            case 0: // do red
                popUp?.color = #colorLiteral(red: 1, green: 0.5960784314, blue: 0.6941176471, alpha: 1)
                popUp?.list = redList
                popUp?.indexList = redIndexList
                popUp?.category = "red"
            case 1:  // do orange
                popUp?.color = #colorLiteral(red: 1, green: 0.7859908342, blue: 0.5220321417, alpha: 1)
                popUp?.list = orangeList
                popUp?.indexList = orangeIndexList
                popUp?.category = "orange"
            case 2:  // do blue
                popUp?.color = #colorLiteral(red: 0.5487036109, green: 0.8750793338, blue: 1, alpha: 1)
                popUp?.list = blueList
                popUp?.indexList = blueIndexList
                popUp?.category = "blue"
            case 3:  // do green
                popUp?.color = #colorLiteral(red: 0.5415468216, green: 1, blue: 0.6116992235, alpha: 1)
                popUp?.list = greenList
                popUp?.indexList = greenIndexList
                popUp?.category = "green"
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
        classify()
        
    }
    
    /**********************************************************************************************************/
    // DELEGATE METHOD BETWEEN SMALL BOX AND POP UP
    // CORE DATA USING METHOD
    
    func appendTodo (_ newTodo : Todo) -> Int{
        mainList.append(newTodo)
        user?.todoList = mainList
        PersistenceService.saveContext()
        classify() // re-classify
        return mainList.count - 1
    }
    
    func editContent (_ newText : String, ogIndex index : Int) {
        // change main data
        mainList[index].content = newText
        user?.todoList = []
        PersistenceService.saveContext()
        user?.todoList = mainList
        PersistenceService.saveContext()
        classify()
    }
    
    // PROBLEM HERE TO BE FIXED!!
    func checkBox(ogIndex index : Int) {
        print("Start of saving...\n.\n.\n.\n")
        print("The index for this checkbox is \(index)")
        print("The content for this object is \(mainList[index].content!)")
        print("Made this checkbox into \(mainList[index].done!)")
//        mainList[index].done! = !mainList[index].done!
        user?.todoList = []
        PersistenceService.saveContext() // Save newly created user
        print("During saving this checkbox is \(mainList[index].done!)")
        user?.todoList = mainList
        PersistenceService.saveContext() // Save newly created user
        print("After saving this checkbox is \(mainList[index].done!)")
        print("saved checkbox")
        classify()
        print("After classify this checkbox is \(mainList[index].done!)")
    }
    
    
    
}
