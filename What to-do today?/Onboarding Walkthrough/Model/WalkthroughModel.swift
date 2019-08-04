//
//  WalkthroughModel.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

class WalkthroughModel {
    var title: String
    var subtitle: String
    var icon: String
    
    init(title: String, subtitle: String, icon: String) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}
