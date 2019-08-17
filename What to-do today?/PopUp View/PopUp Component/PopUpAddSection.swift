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
    var index : IndexPath?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.text = NSLocalizedString("Add new todo here", comment: "");
        textView.textColor = UIColor.gray
        textView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RedAddTableViewCell.endEdit),
            name: NSNotification.Name(rawValue: "endEdit"),
            object: nil)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        addRowDelegate?.updateScrollTarget(index!)
        return true
    }
    
    @objc func endEdit () {
        textView.resignFirstResponder()
    }
    
    @IBAction func enterEdit(_ sender: Any) {
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            var addString = textView.text!
            addString = addString.replacingOccurrences(of: "\n", with: "")
            addRowDelegate?.addRow(self, addString)
        }
        textView.text = NSLocalizedString("Add new todo here", comment: "")
        textView.textColor = UIColor.gray;
        expandCellDelegate?.updated()
//        textView.becomeFirstResponder()
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let newCurrText = textView.text.replacingOccurrences(of: " ", with: "")
            if newCurrText == "" {
                textView.text = ""
                textView.resignFirstResponder()
            } else {
                textView.resignFirstResponder()
                textView.becomeFirstResponder()
                textView.text = ""
                textView.textColor = UIColor.black
                return false
            }
        }
        return true
    }
    
}
