//
//  BigBoxViewController + Reload .swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/31.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController {
    
    // call everytime when popup modification method is called
    @objc func reloadToday() {
        list = (user?.todoList)!
        todayOrdersList = (user?.todayOrdersList)!
        print(todayOrdersList)
        todayList = []
        todayIndexList = []
        loadTodayTodoToDict()
        var todayIndexDict : [String? : Int] = [:]
        for i in stride(from: 0, to: list.count, by: 1) {
            if list[i].isToday {
                todayIndexDict[list[i].uuid] = i
            }
        }
        for i in stride(from: 0, to: todayOrdersList.count, by: 1) {
            print(list[todayIndexDict[todayOrdersList[i]]!].content!)
            todayList.append(list[todayIndexDict[todayOrdersList[i]]!])
            todayIndexList.append(todayIndexDict[todayOrdersList[i]]!)
        }
        
//        var upperLeft : [Todo] = []
//        var upperLeftIndex : [Int] = []
//        var upperRight :[Todo] = []
//        var upperRightIndex : [Int] = []
//        var bottomLeft : [Todo] = []
//        var bottomLeftIndex : [Int] = []
//        var bottomRight : [Todo] = []
//        var bottomRightIndex : [Int] = []
//        for i in stride(from: 0, to: list.count, by: 1) {
//            if list[i].isToday {
//                switch list[i].category! {
//                case "red":
//                    upperLeft.append(list[i])
//                    upperLeftIndex.append(i)
//                case "orange":
//                    upperRight.append(list[i])
//                    upperRightIndex.append(i)
//                case "blue":
//                    bottomLeft.append(list[i])
//                    bottomLeftIndex.append(i)
//                case "green":
//                    bottomRight.append(list[i])
//                    bottomRightIndex.append(i)
//                default: return
//                }
//            }
//        }
//        todayList = upperLeft + upperRight + bottomLeft + bottomRight
//        todayIndexList = upperLeftIndex + upperRightIndex + bottomLeftIndex + bottomRightIndex
        tableView.reloadData()
    }
    
    // call it when first load and whenever there's change in number of todo
    func loadTodayTodoToDict () {
        todayDict = [:]
        for todo in list {
            if todo.isToday {
                print(todo.uuid)
                todayDict[todo.uuid] = todo
            }
        }
        print("Here")
        print(todayDict)
        //todayList = createTodayList()
    }
    
    
    @IBAction func clearDone(_ sender: Any) {
        Constants.heavyHaptic.impactOccurred()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endEdit"), object: nil)
        var count : Int = 0
        var tempTodo: [Todo] = []
        for todo in list {
            if todo.done {
                count = count + 1
            } else {
                tempTodo.append(todo)
            }
        }
        if count == 0 {
            let alert = UIAlertController(title: NSLocalizedString("Hmm", comment: ""), message: NSLocalizedString("You haven't done any todo yet...", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Clear done", comment: ""), message: NSLocalizedString("Clear all the done todos?", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                self.user?.todoList = []
                PersistenceService.saveContext()
                self.user?.todoList = tempTodo
                PersistenceService.saveContext()
                self.reloadToday()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
                let head = NSLocalizedString("You finished ", comment: "")
                let body = NSLocalizedString(" today!", comment: "")
                let tail = NSLocalizedString("Keep it going!", comment: "")
                let placeholder : String = count == 1 ? NSLocalizedString("todo", comment: "") : NSLocalizedString("todos", comment: "")
                let comment = head + String(count) + placeholder + body + "\n" + tail
                let congrat = UIAlertController(title: NSLocalizedString("YAY", comment: ""), message: comment, preferredStyle: .alert)
                congrat.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                self.present(congrat, animated: true, completion: nil)
            } ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
     func createTodayList() -> [Todo]{
        let todayList : [Todo] = []
        for uuid in todayOrdersList {
     
        }
        return []
     }
    
}
