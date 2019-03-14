//
//  PopUpViewBase.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/13.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

//import UIKit
//
//class PopUpViewController: UIViewController,  ExpandingCellDelegate, AddTableViewCellDelegate {
//    
//    
//    var list = [String]()
//    var expandingCellHeight: CGFloat = 200
//    var expandingIndexRow: Int = 0
//    weak var tableView: UITableView!
//    
//    func updated(height: CGFloat) {
//        expandingCellHeight = height
//        UIView.setAnimationsEnabled(false)
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
//        let indexPath = IndexPath(row: expandingIndexRow, section: 0)
//        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//    }
//    
//    func addRow(_ sender:UITableViewCell, _ newString:String) {
//        list.append(newString)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: list.count - 1, section: 0)], with: .automatic)
//        tableView.endUpdates()
//    }
//    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
//        tap.cancelsTouchesInView = false
//        self.view.addGestureRecognizer(tap)
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        // implement here?
//    }
//    
//    func showAnimate() {
//        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//        self.view.alpha = 0.0
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.alpha = 1.0
//            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        })
//    }
//    
//    func removeAnimate() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.view.alpha = 0.0;
//        }, completion: {(finished : Bool) in
//            if (finished) {
//                self.view.removeFromSuperview()
//            }
//        })
//    }
//}
