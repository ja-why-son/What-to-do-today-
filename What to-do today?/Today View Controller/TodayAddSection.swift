//
//  TodayAddSection.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/18.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class TodayAddTableViewCell: addTableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.text = "Add new todo here";
        textView.textColor = UIColor.gray
        textView.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            var addString = textView.text!
            addString = addString.replacingOccurrences(of: "\n", with: " ")
            addTodayRowDelegate?.addRow(addString)
            print(addString)
        }
        textView.text = "Add new todo here"
        textView.textColor = UIColor.gray;
        expandCellDelegate?.updated()
    }
    
}
