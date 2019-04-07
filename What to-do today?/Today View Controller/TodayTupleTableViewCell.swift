//
//  TodayTupleTableViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

protocol TableCellTodoTodayBoxDelegate {
    func doneEdittingTodayCell(_ newText : String, _ sender : TodayTupleTableViewCell)
}


class TodayTupleTableViewCell: ExpandableTableViewCell {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkBox: UIButton!
    
    var originalText : String?
    var tableCellTodoTodayBoxDelegate : TableCellTodoTodayBoxDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        originalText = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != originalText {
            tableCellTodoTodayBoxDelegate?.doneEdittingTodayCell(textView.text, self)
        }
    }
}


