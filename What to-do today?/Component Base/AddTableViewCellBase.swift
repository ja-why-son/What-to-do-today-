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
    func updateScrollTarget (_ indexPath : IndexPath)
}

class addTableViewCell: ExpandableTableViewCell {
    
    var addRowDelegate: AddTableViewCellDelegate?
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = "";
        textView.textColor = UIColor.black;
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                textView.text = NSLocalizedString("Add new todo here", comment: "")
                textView.textColor = UIColor.gray; 
            }
        return true
    }
}
