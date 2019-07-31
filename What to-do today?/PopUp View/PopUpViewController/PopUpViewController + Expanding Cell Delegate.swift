//
//  PopUpViewController + Expanding Cell Delegate.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension PopUpViewController : ExpandingCellDelegate {
    
    func updated() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}
