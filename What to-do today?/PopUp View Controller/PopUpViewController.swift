//
//  PopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData


class PopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate, TableCellTodoSmallBoxDelegate {
    
    // UI Components
    @IBOutlet weak var expandBox: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UITextField!
    
    // Variables
    var user : User? = nil
    var list = [Todo]()
    var indexList = [Int]()
    var expandingCellHeight: CGFloat = 200
    var color : UIColor? = nil
    var category : String? = nil
    var delegate : SmallBoxPopUpDelegate?
    var categoryName : String? = nil
    var labelTag : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // STYLING
        label.tag = labelTag!
        label.text = categoryName
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        backButton.backgroundColor = UIColor.clear
        expandBox.layer.cornerRadius = 15
        expandBox.backgroundColor = color
        self.showAnimate()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        //Misc
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PopUpViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(PopUpViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    /**********************************************************************************************************/
    // Show and close animation
    // Animation
    //
    //
    func showAnimate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        ToDoViewController().dataSource = nil
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: {(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
    
    @IBAction func closeRedPopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    /**********************************************************************************************************/
    // table view presentation
    //
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    // Creating the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == list.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addSection", for: indexPath) as! RedAddTableViewCell
            cell.expandCellDelegate = self
            cell.addRowDelegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tuple", for: indexPath) as! PopUpTableViewCell
        cell.expandCellDelegate = self
        cell.tableCellTodoSmallBoxDelegate = self
        let currTodo = list[indexPath.row]
        cell.textView.text = currTodo.content
        cell.checkBox.tag = indexPath.row
        if currTodo.done! == false {
            cell.checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checked_checkbox"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if list.isEmpty || indexPath.row == list.count {
            return nil
        }
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete item")
            self.deleteTodo(indexPath)
            success(true)
        })
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if list.isEmpty || indexPath.row == list.count {
            return nil
        }
        if !list[indexPath.row].isToday {
            let todayAction = UIContextualAction(style: .normal, title:  "Today", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Move to today")
                self.todayOrNot(indexPath)
                success(true)
            })
            todayAction.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            return UISwipeActionsConfiguration(actions: [todayAction])
        }
        let notTodayAction = UIContextualAction(style: .normal, title: "Later", handler: {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Move out from today")
            self.todayOrNot(indexPath)
            success(true)
        })
        notTodayAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return UISwipeActionsConfiguration(actions: [notTodayAction])
    }
    
    /**********************************************************************************************************/
    // keyboard configuration
    //
    //
    //
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification);
        backButton.isEnabled = false
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification);
        backButton.isEnabled = true
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableView.estimatedRowHeight, right: 0) // if there's a problem think about using the frame and content size
            tableView.scrollIndicatorInsets = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        let tableRect = tableView.rect(forSection: 0)
        tableView.scrollRectToVisible(tableRect, animated: true)
    }
    
    /**********************************************************************************************************/
    // customized method
    
    func updated() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    /**********************************************************************************************************/
    // USE CORE DATA
    //
    //
    
    // APPEND NEW ROW
    // make append delegate method return the list.count
    func addRow(_ sender:UITableViewCell, _ newContent:String) {
        let newTodo = Todo(content: newContent, category: self.category!, isToday: false)
        self.list.append(newTodo)
        let newIndex = delegate?.appendTodo(newTodo)
        self.indexList.append(newIndex!)
        let offset = list.count == 0 ? 0 : 1
        let indexPath = IndexPath(item: list.count - offset, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    
    // EDIT CONTENT
    // Send the new text and the original index back to small box view controller to edit the main data
    // also edit local(popup) list
    func doneEdittingPopUpCell(_ newText : String, _ sender : PopUpTableViewCell) {
        let index = tableView.indexPath(for: sender)![1]
        //print(index)
        list[index].content = newText
        //print(indexList[index])
        delegate?.editContent(newText, ogIndex: indexList[index])
        if list[index].isToday {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        }
    }
    
    // DONE OR NOT DONE
    @IBAction func checkCheckbox(_ sender : UIButton) {
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
//        tableView(tableView, cellForRowAt: indexPath)
        delegate?.moveTodayOrOut(ogIndex: indexList[cellIndex])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
    }
    
    // DELETE ROW
    func deleteTodo(_ indexPath : IndexPath) {
        print("Indexpath is \(indexPath)")
        let isToday : Bool = list[indexPath.row].isToday
        list.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        indexList = (delegate?.deleteTodo(ogIndex: indexList[indexPath.row], category!))!
        if isToday {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        }
    }
    
}
