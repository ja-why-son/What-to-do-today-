//
//  BigBoxViewController + Keyboard Op.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/31.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if todayIsEditting {
            adjustForKeyboard(notification: notification);
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if todayIsEditting {
            adjustForKeyboard(notification: notification);
        }
        todayIsEditting = false
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        print("wrong place")
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
        //        let tableRect = tableView.rect(forSection: 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        //        tableView.scrollRectToVisible(tableRect, animated: true)
    }
}
