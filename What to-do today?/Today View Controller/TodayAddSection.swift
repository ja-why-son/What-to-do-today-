//
//  TodayAddSection.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/1.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

protocol TodayAddTableViewCellDelegate {
    func addRow(_ sender:TodayAddTableViewCell, _ newString:String)
}

class TodayAddTableViewCell: ExpandableTableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    var delegate_one: TodayAddTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            let addString = textView.text!
            print(addString)
            delegate_one?.addRow(self, addString)
            textView.text = ""
        }
        
    }
}
