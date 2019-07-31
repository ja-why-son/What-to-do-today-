//
//  PopUpViewController + Table View, Datasource Delegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    // Creating the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == list.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSection", for: indexPath) as! RedAddTableViewCell
            cell.expandCellDelegate = self
            cell.addRowDelegate = self
            cell.index = indexPath
            print("Create add section")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tuple", for: indexPath) as! PopUpTableViewCell
        cell.expandCellDelegate = self
        cell.tableCellTodoSmallBoxDelegate = self
        cell.indexPath = indexPath
        let currTodo = list[indexPath.row]
        cell.textView.text = currTodo.content
        if currTodo.isToday == true {
            cell.textView.font = UIFont.systemFont(ofSize: cell.textView.font!.pointSize, weight: UIFont.Weight.heavy)
        } else {
            cell.textView.font = UIFont.systemFont(ofSize: cell.textView.font!.pointSize, weight: UIFont.Weight.regular)
        }
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
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != list.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.row != list.count {
            let todo = list[sourceIndexPath.row]
            let start = indexList[sourceIndexPath.row]
            let end = indexList[destinationIndexPath.row]
            delegate?.swapTodo(startFrom: start, endAt: end)
            list.remove(at: sourceIndexPath.row)
            list.insert(todo, at: destinationIndexPath.row)
            indexList.remove(at: sourceIndexPath.row)
            indexList.insert(start, at: destinationIndexPath.row)
            tableView.reloadData()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
    }
}
