//
//  SmallBoxViewController + Theme.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/8/19.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController {
    
    func getColor () {
        let themeNum = (user?.theme)!
        let theme = Constants.themes[Int(themeNum)]
        upperLeftColor = theme[0]
        upperRightColor = theme[1]
        bottomLeftColor = theme[2]
        bottomRightColor = theme[3]
        redBox.backgroundColor = upperLeftColor
        orangeBox.backgroundColor = upperRightColor
        blueBox.backgroundColor = bottomLeftColor
        greenBox.backgroundColor = bottomRightColor
    }
    
    @IBAction func setColor () {
        Constants.heavyHaptic.impactOccurred()
        let prevTheme = (user?.theme)!
        user?.theme = (prevTheme + 1) % 4
        PersistenceService.saveContext()
        getColor()
    }
}
