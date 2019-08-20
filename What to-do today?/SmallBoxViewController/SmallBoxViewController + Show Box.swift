//
//  SmallBoxViewController + Open Box.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController {
    
    @IBAction func showBox (_ sender :  Any) {
        var senderTag : Int = -1
        let gesture = sender as? UITapGestureRecognizer
        senderTag = (gesture?.view!.tag)!
        popUp = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController)
        popUp?.user = user
        popUp?.labelTag = senderTag
        switch senderTag {
        case 0: // do red
            popUp?.color = upperLeftColor
            popUp?.list = redList
            popUp?.indexList = redIndexList
            popUp?.category = "red"
            popUp?.categoryName = categoriesList[0]
        case 1:  // do orange
            popUp?.color = upperRightColor
            popUp?.list = orangeList
            popUp?.indexList = orangeIndexList
            popUp?.category = "orange"
            popUp?.categoryName = categoriesList[1]
        case 2:  // do blue
            popUp?.color = bottomLeftColor
            popUp?.list = blueList
            popUp?.indexList = blueIndexList
            popUp?.category = "blue"
            popUp?.categoryName = categoriesList[2]
        case 3:  // do green
            popUp?.color = bottomRightColor
            popUp?.list = greenList
            popUp?.indexList = greenIndexList
            popUp?.category = "green"
            popUp?.categoryName = categoriesList[3]
        default: return // do last one
        }
        self.addChild(popUp!)
        popUp!.view.frame = self.view.frame
        self.view.addSubview(popUp!.view)
        popUp!.didMove(toParent: self)
        popUp!.delegate = self
    }
}
