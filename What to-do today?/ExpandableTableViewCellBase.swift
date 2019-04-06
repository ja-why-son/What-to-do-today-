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
        print("textViewDidChange works")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let newText = textView.text!.replacingOccurrences(of: "\n", with: " ")
        textView.text = newText
        expandCellDelegate?.updated()
    }
    
}

