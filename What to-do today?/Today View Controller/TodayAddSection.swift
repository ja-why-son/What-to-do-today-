//
//  TodayAddSection.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/1.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class TodayAddTableViewCell: ExpandableTableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
