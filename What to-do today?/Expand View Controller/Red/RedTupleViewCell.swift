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
    }
    
//    @IBAction func checkCheckBox(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//    }
}
