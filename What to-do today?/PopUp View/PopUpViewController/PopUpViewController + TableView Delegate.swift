//
//  PopUpViewController + TableView Delegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if list.isEmpty || indexPath.row == list.count {
            return nil
        }
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete todo")
            self.deleteTodo(indexPath)
            success(true)
        })
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(list.isEmpty || indexPath.row == list.count || isMakingEdit)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if list.isEmpty || indexPath.row == list.count {
            return nil
        }
        
        let todayAction = UIContextualAction(style: .normal, title:  "Today", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Move to today")
            self.todayOrNot(indexPath)
            success(true)
        })
        todayAction.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let notTodayAction = UIContextualAction(style: .normal, title: "Later", handler: {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Move out from today")
            self.todayOrNot(indexPath)
            success(true)
        })
        notTodayAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        if !list[indexPath.row].isToday {
            return UISwipeActionsConfiguration(actions: [todayAction])
        } else if list[indexPath.row].isToday {
            return UISwipeActionsConfiguration(actions: [notTodayAction])
        }
        return nil
    }
}
