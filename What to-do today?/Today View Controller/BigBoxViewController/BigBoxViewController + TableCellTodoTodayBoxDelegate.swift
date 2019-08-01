//
//  BigBoxViewController + TableCellTodoTodayBoxDelegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/31.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController : TableCellTodoTodayBoxDelegate {
    
    @IBAction func checkCheckBox(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let index = sender.tag
        list[todayIndexList[index]].done! = !list[todayIndexList[index]].done!
        user?.todoList! = []
        PersistenceService.saveContext()
        user?.todoList! = list
        PersistenceService.saveContext()
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
    }
    
    // edit the text in the today box
    func doneEdittingTodayCell(_ newText: String, _ sender : TodayTupleTableViewCell) {
        let index = tableView.indexPath(for: sender)?.row
        if newText.isEmpty {
            todayList.remove(at: index!)
            tableView.deleteRows(at: [IndexPath(row: index!, section: 0)], with: .fade)
            list.remove(at: todayIndexList[index!])
        } else {
            list[todayIndexList[index!]].content = newText
        }
        user?.todoList! = []
        PersistenceService.saveContext()
        user?.todoList! = list
        PersistenceService.saveContext()
        reloadToday()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
    }
    
    func moveOutToday(_ sender : TodayTupleTableViewCell) {
        let index = tableView.indexPath(for: sender)?.row
        sender.textView.resignFirstResponder()
        list[todayIndexList[index!]].isToday = !list[todayIndexList[index!]].isToday
        todayList.remove(at: index!)
        todayIndexList.remove(at: index!)
        user?.todoList! = []
        PersistenceService.saveContext()
        user?.todoList! = list
        PersistenceService.saveContext()
        reloadToday()
    }
    
    func todayEnterEdit() {
        todayIsEditting = true
    }
    
}
