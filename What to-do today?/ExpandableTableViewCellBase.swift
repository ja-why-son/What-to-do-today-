//
//  ExpandableTableViewCellBase.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/2/16.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandingCellDelegate {
    func updated()
}


class ExpandableTableViewCell: UITableViewCell, UITextViewDelegate {
        
    var expandCellDelegate: ExpandingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        expandCellDelegate?.updated()
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
}

