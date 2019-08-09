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
        Constants.heavyHaptic.impactOccurred()
        let index = sender.tag
        list[todayIndexList[index]].done! = !list[todayIndexList[index]].done!
        saveData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
    }
    
    // edit the text in the today box
    func doneEdittingTodayCell(_ newText: String, _ sender : TodayTupleTableViewCell) {
        let index = tableView.indexPath(for: sender)?.row
        if newText.isEmpty {
            todayList.remove(at: index!)
            tableView.deleteRows(at: [IndexPath(row: index!, section: 0)], with: .fade)
            let uuid = list[todayIndexList[index!]].uuid!
            list.remove(at: todayIndexList[index!])
            todayOrdersList.remove(at: todayOrdersList.index(of: uuid)!)
            // here
        } else {
            list[todayIndexList[index!]].content = newText
        }
        saveData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSmallBox"), object: nil)
    }
    
    func moveOutToday(_ sender : TodayTupleTableViewCell) {
        Constants.mediumHaptic.impactOccurred()
        let index = tableView.indexPath(for: sender)?.row
        sender.textView.resignFirstResponder()
        list[todayIndexList[index!]].isToday = !list[todayIndexList[index!]].isToday
        let uuid = list[todayIndexList[index!]].uuid!
        todayOrdersList.remove(at: todayOrdersList.index(of: uuid)!)
        todayList.remove(at: index!)
        todayIndexList.remove(at: index!)
        saveData()
    }
    
    func todayEnterEdit() {
        todayIsEditting = true
    }
    
    func saveData() {
        user?.todoList! = []
        user?.todayOrdersList = []
        PersistenceService.saveContext()
        user?.todoList! = list
        user?.todayOrdersList = todayOrdersList
        PersistenceService.saveContext()
        reloadToday()
    }
    
}
