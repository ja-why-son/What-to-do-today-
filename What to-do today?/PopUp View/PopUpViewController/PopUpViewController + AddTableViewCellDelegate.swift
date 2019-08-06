//
//  PopUpViewController + AddTableViewCellDelegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController : AddTableViewCellDelegate {
    
    // APPEND NEW ROW
    // make append delegate method return the list.count
    func addRow(_ sender:UITableViewCell, _ newContent:String) {
        Constants.mediumHaptic.impactOccurred()
        let newTodo = Todo(content: newContent, category: self.category!, isToday: false)
        self.list.append(newTodo)
        let newIndex = delegate?.appendTodo(newTodo)
        self.indexList.append(newIndex!)
        let offset = list.count == 0 ? 0 : 1
        let indexPath = IndexPath(item: list.count - offset, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        print("\(newContent) was added");
       scrollTarget = IndexPath(row: list.count - 1, section: 0)
        
    }
    
    func updateScrollTarget (_ indexPath : IndexPath) {
        scrollTarget = IndexPath(row: indexPath.row, section: indexPath.section)
    }
}
