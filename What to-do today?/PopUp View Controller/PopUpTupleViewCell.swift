//
//  RedTupleViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

protocol TableCellTodoSmallBoxDelegate {
    func doneEditting(_ newText : String, _ sender : RedTupleTableViewCell)
}

class RedTupleTableViewCell: ExpandableTableViewCell {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var originalText : String?
    
    var tableCellTodoSmallBoxDelegate : TableCellTodoSmallBoxDelegate?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        originalText = textView.text
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != originalText {
            tableCellTodoSmallBoxDelegate?.doneEditting(textView.text, self)
        }
    }
    
}
