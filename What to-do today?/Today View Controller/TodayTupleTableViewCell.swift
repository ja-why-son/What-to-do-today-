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
    func moveOutToday(_ sender : TodayTupleTableViewCell)
}


class TodayTupleTableViewCell: ExpandableTableViewCell {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var notToday: UIButton!
    @IBOutlet weak var textRightConstraint: NSLayoutConstraint!
    
    var originalText : String?
    var tableCellTodoTodayBoxDelegate : TableCellTodoTodayBoxDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(TodayTupleTableViewCell.sayHello))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        notToday.isEnabled = false
        notToday.isHidden = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TodayTupleTableViewCell.endEdit),
            name: NSNotification.Name(rawValue: "endEdit"),
            object: nil)
    }
    
    @objc func endEdit () {
        textView.resignFirstResponder()
    }
    
    @objc func sayHello() {
        print("hello")
        tableCellTodoTodayBoxDelegate?.doneEdittingTodayCell("", self)
    }
    
    @IBAction func sayWOW(_ sender: Any) {
        print("wow")
        tableCellTodoTodayBoxDelegate?.moveOutToday(self)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        originalText = textView.text
        notToday.isEnabled = true
        notToday.isHidden = false
        textRightConstraint.constant = 30
        notToday.layer.zPosition = 10000
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textRightConstraint.constant = 13
        notToday.isEnabled = false
        notToday.isHidden = true
        if textView.text != originalText {
            tableCellTodoTodayBoxDelegate?.doneEdittingTodayCell(textView.text, self)
        }
        
        
    }
}


