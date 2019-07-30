//
//  PopUpTextField.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/4/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

protocol LabelSmallBoxDelegate {
    func editLabel()
}

class PopUpTextField: UITextField, UITextFieldDelegate {
    
    var originalLabel : String?
    var labelSmallBoxDelegate : LabelSmallBoxDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "label is editting"), object: nil, userInfo: nil)
        return true
    }

    func textFieldDidBeginEditing(_ textField : UITextField) {
        originalLabel = self.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField : UITextField) {
        if textField.text != originalLabel {
            let info : [String : Int] = [textField.text!: textField.tag]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload label"), object: nil, userInfo: info)
        }
    }
    
    
}
