//
//  GreenTupleTableViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/12.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class GreenTupleTableViewCell: ExpandableTableViewCell {
    
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
}
