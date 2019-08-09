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
        isMakingEdit = true
        adjustForKeyboard(notification: notification);
        backButton.isEnabled = false
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isMakingEdit = false
        adjustForKeyboard(notification: notification);
        backButton.isEnabled = true
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.tableView.contentInset = .zero
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        if !labelEdit! {
            if let indexPath = scrollTarget {
                if (tableView.numberOfRows(inSection: 0) > indexPath.row) &&
                    indexPath.row >= 0{
                    print("scroll target is \(scrollTarget)" )
                    self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .middle, animated: true)
                }
            }
        }
    }
}
