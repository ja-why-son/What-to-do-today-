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
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            var addString = textView.text!
            addString = addString.replacingOccurrences(of: "\n", with: " ")
            addRowDelegate?.addRow(self, addString)
            textView.text = ""
        }
        expandCellDelegate?.updated(height: 100)
    }
}
