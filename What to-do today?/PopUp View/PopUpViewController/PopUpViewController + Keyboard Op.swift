//
//  PopUpViewController + Keyboard Op.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController {
    
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
            self.tableView.contentInset = .zero
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            //            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        if !labelEdit! {
            if let indexPath = scrollTarget {
                self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .middle, animated: true)
            }
        }
        
        
        //        let tableRect = tableView.rect(forSection: 0)
        //        tableView.scrollRectToVisible(tableRect, animated: false)
        
    }
}
