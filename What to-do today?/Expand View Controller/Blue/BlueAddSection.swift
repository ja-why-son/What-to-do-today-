//
//  BlueAddSection.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/12.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class BlueAddTableViewCell: addTableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
}
