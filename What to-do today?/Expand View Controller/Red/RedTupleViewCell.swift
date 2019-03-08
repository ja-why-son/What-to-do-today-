//
//  RedTupleViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/6.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class RedTupleTableViewCell: ExpandableTableViewCell {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var textView: UITextView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal)
        checkBox.setImage(UIImage(named: "checked_checkbox"), for: .selected)
    }
    
    @IBAction func checkCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text!.replacingOccurrences(of: "\n", with: " ")
        expandCellDelegate?.updated(height: 100)
    }
}
