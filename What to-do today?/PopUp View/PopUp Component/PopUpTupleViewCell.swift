//
//  RedTupleViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

protocol TableCellTodoSmallBoxDelegate {
    func doneEdittingPopUpCell(_ newText : String, _ sender : PopUpTableViewCell)
    func updateScrollTarget(_ indexPath : IndexPath)
}

class PopUpTableViewCell: ExpandableTableViewCell {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var originalText : String?
    var indexPath : IndexPath?
    
    var tableCellTodoSmallBoxDelegate : TableCellTodoSmallBoxDelegate?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PopUpTableViewCell.endEdit),
            name: NSNotification.Name(rawValue: "endEdit"),
            object: nil)
    }
    
    @objc func endEdit () {
        textView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        tableCellTodoSmallBoxDelegate?.updateScrollTarget(indexPath!)
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        originalText = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != originalText {
            tableCellTodoSmallBoxDelegate?.doneEdittingPopUpCell(textView.text, self)
        }
    }
    
}
