//
//  PopUpViewController + TableCellTodoSmallBoxDelegate .swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController : TableCellTodoSmallBoxDelegate  {
    
    // EDIT CONTENT
    // Send the new text and the original index back to small box view controller to edit the main data
    // also edit local(popup) list
    func doneEdittingPopUpCell(_ newText : String, _ sender : PopUpTableViewCell) {
        let index = tableView.indexPath(for: sender)![1]
        let isToday : Bool = list[index].isToday
        list[index].content = newText
        // TODO if newText is empty, delete row
        // note that list[index].isToday is gonna break
        // need to investigate to see if the index is the same as
        // indexPath.row down in the remove method
        if newText.isEmpty {
            list.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            indexList = (delegate?.deleteTodo(ogIndex: indexList[index], category!))!
        } else {
            delegate?.editContent(newText, ogIndex: indexList[index])
        }
        if isToday {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        }
    }
    
    // DONE OR NOT DONE
    @IBAction func checkCheckbox(_ sender : UIButton) {
        tableView.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let index = sender.tag
        list[index].done! = !list[index].done!
        delegate?.checkBox(ogIndex: indexList[index])
        tableView.reloadData()
        if list[index].isToday {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        }
    }
    
    // MOVE TO TODAY OR MOVE OUT OF TODAY
    func todayOrNot(_ indexPath : IndexPath) {
        let cellIndex = indexPath.row
        list[cellIndex].isToday = !list[cellIndex].isToday
        delegate?.moveTodayOrOut(ogIndex: indexList[cellIndex])
        //        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
    }
    
    // DELETE ROW
    func deleteTodo(_ indexPath : IndexPath) {
        let isToday : Bool = list[indexPath.row].isToday
        indexList = (delegate?.deleteTodo(ogIndex: indexList[indexPath.row], category!))!
        list.remove(at: indexPath.row)
        //        indexList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if isToday {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        }
        var indexPaths : [IndexPath] = []
        if indexPath.row <= list.count - 1 {
            print("doing reload for rows after the delete")
            for i in indexPath.row ... list.count - 1 {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
        }
        tableView.reloadData()
        //        tableView.estimatedRowHeight = 100
        //        tableView.reloadRows(at: indexPaths, with: .automatic)
        //        UIView.performWithoutAnimation{tableView.reloadData()}
    }
}