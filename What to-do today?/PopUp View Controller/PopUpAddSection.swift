//
//  RedAddSection.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/7.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class RedAddTableViewCell: addTableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.text = "Add new todo here";
        textView.textColor = UIColor.gray
        textView.delegate = self
    }
    
    @IBAction func enterEdit(_ sender: Any) {
        textView.becomeFirstResponder()
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
    
}
