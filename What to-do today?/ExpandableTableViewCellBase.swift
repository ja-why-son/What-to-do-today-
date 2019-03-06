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
    func updated(height: CGFloat)
}

extension UITextView {
    /**
     Calculates if new textview height (based on content) is larger than a base height
     
     - parameter baseHeight: The base or minimum height
     
     - returns: The new height
     */
    func newHeight(withBaseHeight baseHeight: CGFloat) -> CGFloat {
        
        // Calculate the required size of the textview
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = frame
        
        // Height is always >= the base height, so calculate the possible new height
        let height: CGFloat = newSize.height > baseHeight ? newSize.height : baseHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        return newFrame.height
    }
}

class ExpandableTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var delegate: ExpandingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.newHeight(withBaseHeight: 200)
        delegate?.updated(height: height)
    }
    
    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        print("hello")
        textField.resignFirstResponder()
        return true
    }
}

