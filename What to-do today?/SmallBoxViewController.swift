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
    var list = [Todo]()
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
        list = (user?.todoList)!
        classify()
    }
    
    func classify () {
        redList = []
        orangeList = []
        blueList = []
        greenList = []
        redIndexList = []
        orangeIndexList = []
        blueIndexList = []
        greenIndexList = []
        for i in stride(from: 0, to: list.count, by: 1) {
            switch list[i].category {
            case "red":
                // do red
                redList.append(list[i])
                redIndexList.append(i)
            case "orange":
                // do orange
                orangeList.append(list[i])
                orangeIndexList.append(i)
            case "blue":
                // do blue
                blueList.append(list[i])
                blueIndexList.append(i)
            case "green":
                // do green
                greenList.append(list[i])
                greenIndexList.append(i)
            default:
                print("error")
            }
        }
        list = (user?.todoList)!
    }
    
    
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
    
    func appendTodo (_ newTodo : Todo) -> Int{
        list.append(newTodo)
        user?.todoList = list
        PersistenceService.saveContext()
        classify() // re-classify
        return list.count - 1
    }
    
    func editContent (_ newText : String, ogIndex index : Int) {
        // change main data
        list[index].content = newText
        user?.todoList = []
        PersistenceService.saveContext()
        user?.todoList = list
        PersistenceService.saveContext()
        classify()
    }
    
    
    @IBAction func eraseData(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Data", message: "Data Cleared", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        user?.todoList =  []
        list = []
        PersistenceService.saveContext()
        classify()
    
    }
}
