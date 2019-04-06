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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    
}
