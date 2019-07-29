//
//  PopUpViewController.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices


class PopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ExpandingCellDelegate, AddTableViewCellDelegate, TableCellTodoSmallBoxDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
 
    
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
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
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
        if currTodo.isToday == true {
            cell.textView.font = UIFont.systemFont(ofSize: cell.textView.font!.pointSize, weight: UIFont.Weight.heavy)
        } else {
            cell.textView.font = UIFont.systemFont(ofSize: cell.textView.font!.pointSize, weight: UIFont.Weight.regular)
        }
        cell.checkBox.tag = indexPath.row
        if currTodo.done! == false {
            cell.checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(named: "checked_checkbox"), for: .normal)
            let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: cell.textView.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttributes([NSAttributedString.Key.font: cell.textView.font!], range: NSMakeRange(0, attributeString.length))
            cell.textView.attributedText = attributeString
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(list.isEmpty || indexPath.row == list.count)
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
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row == list.count {
            return []
        }
//        let data = String(indexPath.row).data(using: .utf8)
        let todoItem = list[indexPath.row]
        let itemProvider = NSItemProvider(object: todoItem)
//        let itemProvider = NSItemProvider()
//        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
//            completion(data, nil)
//            return nil
//        }
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return[dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let estilo = UIDragPreviewParameters()
        estilo.backgroundColor = color
        return estilo
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: Todo.self)
    }
    
    /**
     A drop proposal from a table view includes two items: a drop operation,
     typically .move or .copy; and an intent, which declares the action the
     table view will take upon receiving the items. (A drop proposal from a
     custom view does includes only a drop operation, not an intent.)
     */
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        var isEmpty : Bool = false
        session.loadObjects(ofClass: Todo.self, completion: { (todos) in
            if todos.isEmpty {
                isEmpty = true
            }
        })
        if isEmpty {
            return UITableViewDropProposal(operation: .forbidden)
        }
        if let _ = destinationIndexPath {
            if destinationIndexPath!.row >= list.count {
                return UITableViewDropProposal(operation: .forbidden)
            }
        } else {
            return UITableViewDropProposal(operation: .forbidden)
        }
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let row = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: row, section: 0)
        }
        
        coordinator.session.loadObjects(ofClass: Todo.self) { (todos) in
            let todoItems = todos as! [Todo]
            var indexPaths = [IndexPath]()
            for (_, item) in todoItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row, section: 0)
                self.list.insert(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let estilo = UIDragPreviewParameters()
        estilo.backgroundColor = color
        return estilo
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
//            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableView.estimatedRowHeight, right: 0) // if there's a problem think about using the frame and content size
//            tableView.scrollIndicatorInsets = .zero
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        tableView.scrollIndicatorInsets = tableView.contentInset
        let tableRect = tableView.rect(forSection: 0)
        tableView.scrollRectToVisible(tableRect, animated: false)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endEdit"), object: nil)
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
//        UIView.performWithoutAnimation{tableView.reloadData()}
        
    }
    
    
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
        print("index is \(index)");
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
        print("check box is \(index)")
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
        print("index path is \(indexPath)");
//        for i in indexPath.row + 1 ... list.count - 1 {
//            tableView.cellForRow(at: IndexPath(row: i, section: 0)).check
//        }
        indexList = (delegate?.deleteTodo(ogIndex: indexList[indexPath.row], category!))!
        list.remove(at: indexPath.row)
//        indexList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if isToday {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadToday"), object: nil)
        }
        var indexPaths : [IndexPath] = []
        if indexPath.row <= list.count - 1 {
            print("doing reload")
            for i in indexPath.row ... list.count - 1 {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
        }
        tableView.reloadRows(at: indexPaths, with: .automatic)
//        UIView.performWithoutAnimation{tableView.reloadData()}
    }
    
 
}
