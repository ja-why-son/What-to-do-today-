//
//  SmallBoxViewController + Edit Label.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController {
    
    @objc func editLabel(_ notification : NSNotification) {
        if let userInfo = notification.userInfo as? [String : Int] {
            let newLabelName = Array(userInfo.keys)[0]
            let labelCategory = Array(userInfo.values)[0]
            categoriesList[labelCategory] = newLabelName
            user?.categoryList = []
            PersistenceService.saveContext()
            user?.categoryList = categoriesList
            PersistenceService.saveContext()
            reloadLabel()
        }
    }
}
