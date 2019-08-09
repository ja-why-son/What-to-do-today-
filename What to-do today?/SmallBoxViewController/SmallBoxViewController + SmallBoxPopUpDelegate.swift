//
//  SmallBoxViewController + SmallBoxPopUpDelegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

extension SmallBoxViewController :  SmallBoxPopUpDelegate {
    
    
    func appendTodo (_ newTodo : Todo) -> Int{
        mainList.append(newTodo)
        user?.todoList = mainList
        PersistenceService.saveContext()
        reload() // re-classify
        return mainList.count - 1
    }
    
    func editContent (_ newText : String, ogIndex index : Int) {
        print("main list index is")
        print(mainList[index])
        mainList[index].content = newText
        saveTodoList()
    }
    
    func checkBox(ogIndex index : Int) {
//        mainList = (user?.todoList)! // not sure why we need it here
        saveTodoList()
    }
    
    func moveTodayOrOut(ogIndex index : Int) {
//        mainList = (user?.todoList)! // same ^^
        editTodayOrder(mainList[index].uuid!)
        saveTodoList()
    }
    
    func deleteTodo(ogIndex index : Int){
        if mainList[index].isToday {
            editTodayOrder(mainList[index].uuid!)
        }
        mainList.remove(at: index)
        saveTodoList()
    }
    
    func swapTodo(startFrom origin: Int, endAt destination: Int) {
        mainList = (user?.todoList)!
        let temp = mainList[origin]
        mainList.remove(at: origin)
        mainList.insert(temp, at: destination)
        saveTodoList()
    }
    
    func getList(forCategory category: String) -> [Todo] {
        switch category {
        case "red" : return redList
        case "orange" : return orangeList
        case "blue" : return blueList
        case "green" : return greenList
        default : return []
        }
    }
    
    func getIndexList(forCategory category: String) -> [Int] {
        switch category {
        case "red" : return redIndexList
        case "orange" : return orangeIndexList
        case "blue" : return blueIndexList
        case "green" : return greenIndexList
        default : return []
        }
    }
    
    func saveTodoList() {
        user?.todoList = []
        PersistenceService.saveContext() // Save newly created user
        user?.todoList = mainList
        PersistenceService.saveContext() // Save newly created user
        reload()
    }
    
    func editTodayOrder(_ uuid : String) {
        todayOrdersList = (user?.todayOrdersList)!
        if todayOrdersList.contains(uuid) {
            todayOrdersList.remove(at: todayOrdersList.index(of: uuid)!)
        } else {
            todayOrdersList.append(uuid)
        }
        user?.todayOrdersList = []
        PersistenceService.saveContext()
        user?.todayOrdersList = todayOrdersList
        PersistenceService.saveContext()
        print(todayOrdersList)
    }
}
