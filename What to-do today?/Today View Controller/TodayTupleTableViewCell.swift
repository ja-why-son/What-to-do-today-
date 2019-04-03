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
    
    var originalText : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
}


