//
//  PopUpTextField.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/4/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit
import CoreData

class PopUpTextField: UITextField, UITextFieldDelegate {
    
    var orginalLabel : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
        delegate = self
    }
//
//    func textFieldDidBeginEditing(_ textField : UITextField) {
//        orginalLabel = self.text
//    }
    
    func textFieldDidEndEditing(_ textField : UITextField) {
        print("hellO")
    }
    
    
}
