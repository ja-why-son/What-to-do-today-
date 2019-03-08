//
//  TodayTupleTableViewCell.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class TodayTupleTableViewCell: ExpandableTableViewCell {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        checkBox.setImage(UIImage(named: "empty_checkbox"), for: .normal)
        checkBox.setImage(UIImage(named: "checked_checkbox"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}


