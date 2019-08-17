//
//  BigBoxViewController + InitialCheck.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/17.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension BigBoxViewController {
    
    @objc func initialCheck() {
        if todayList.isEmpty {
            let alert = UIAlertController(title: NSLocalizedString("Whoops", comment: ""), message: NSLocalizedString("You haven't added anything to today yet...", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
        }
    }
}
