//
//  BigBoxViewController + TableView DataSource Delegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/31.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayList.count
    }
    
    // this method is called multiple times whenever a certain indexPath is asking for a data, therefore, assign "" for index 'list.count'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tuple", for: indexPath) as! TodayTupleTableViewCell
        cell.expandCellDelegate = self
        cell.tableCellTodoTodayBoxDelegate = self
        // change here to render cell content from order list
        // retrieve the info by uuid thru dict
        let currTodo = todayList[indexPath.row]
        cell.textView.text = currTodo.content
        cell.checkBox.tag = indexPath.row
        if currTodo.done! == false {
            cell.checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal)
            let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: cell.textView.text)
            attributeString.addAttributes([NSAttributedString.Key.font: cell.textView.font!], range: NSMakeRange(0, attributeString.length))
            cell.textView.attributedText = attributeString
        } else {
            cell.checkBox.setImage(UIImage(named: "checked_checkbox"), for: .normal)
            let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: cell.textView.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttributes([NSAttributedString.Key.font: cell.textView.font!], range: NSMakeRange(0, attributeString.length))
            cell.textView.attributedText = attributeString
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        if destinationIndexPath.row != list.count {
            let temp = todayOrdersList[sourceIndexPath.row]
            todayOrdersList.remove(at: sourceIndexPath.row)
            todayOrdersList.insert(temp, at: destinationIndexPath.row)
        }
        saveData()
        reloadToday()
        tableView.reloadData()
    }
}
