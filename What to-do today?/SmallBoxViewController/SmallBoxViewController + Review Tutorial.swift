//
//  SmallBoxViewController + Review Tutorial.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/17.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController {
    
    @IBAction func revieTutorial () {
        Constants.mediumHaptic.impactOccurred()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        let walkthroughVC = self.walkthroughVC()
        walkthroughVC.delegate = self
        self.addChildViewControllerWithView(walkthroughVC)
        // can add animation 
    }
}
