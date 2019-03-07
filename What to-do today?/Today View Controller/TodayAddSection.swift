//
//  TodayAddSection.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/1.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit



class TodayAddTableViewCell: addTableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

}
