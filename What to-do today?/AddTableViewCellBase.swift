//
//  AddTableViewCellBase.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

protocol AddTableViewCellDelegate {
    func addRow(_ sender:UITableViewCell, _ newString:String)
}

class addTableViewCell: ExpandableTableViewCell {
    var addRowDelegate: AddTableViewCellDelegate?
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = "";
        textView.textColor = UIColor.black;
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            var addString = textView.text!
            addString = addString.replacingOccurrences(of: "\n", with: " ")
            addRowDelegate?.addRow(self, addString)
            print(addString)
        }
        textView.text = "Add new todo here"
        textView.textColor = UIColor.gray;
        expandCellDelegate?.updated()
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                textView.text = "Add new todo here"
                textView.textColor = UIColor.gray; 
            }
        return true
    }
}
