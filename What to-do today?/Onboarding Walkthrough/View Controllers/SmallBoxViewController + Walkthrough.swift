//
//  SmallBoxViewController + Walkthrough.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/3.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController : ATCWalkthroughViewControllerDelegate {
    
    func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
        UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
            vc.view.removeFromSuperview()
//            let viewControllerToBePresented = UIViewController()
//            self.view.addSubview(viewControllerToBePresented.view)
        }, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        self.removeChildViewController(vc)
        user?.tutorialComplete = true
        PersistenceService.saveContext()
    }
    
    
    func walkthroughVC() -> ATCWalkthroughViewController {
        let viewControllers = walkthroughs.map { ATCClassicWalkthroughViewController(model: $0, nibName: "ATCClassicWalkthroughViewController", bundle: nil) }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        return ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                            bundle: nil,
                                            viewControllers: viewControllers)
    }
}
