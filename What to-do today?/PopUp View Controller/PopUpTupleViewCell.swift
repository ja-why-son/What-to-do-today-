//
//  RedTupleViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

protocol tableCellTodoDelegate {
    func doneEditting(_ newText : String, _ sender : RedTupleTableViewCell)
}

class RedTupleTableViewCell: ExpandableTableViewCell {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var originalText : String?
    
    var tableCellTodoDelegate : tableCellTodoDelegate?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        originalText = textView.text
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != originalText {
            tableCellTodoDelegate?.doneEditting(textView.text, self)
        }
    }
    
}
