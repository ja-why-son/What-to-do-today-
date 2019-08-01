//
//  SmallBoxViewController + Reload.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController {
    
    func reloadLabel () {
        redLabel.text = categoriesList[0]
        orangeLabel.text = categoriesList[1]
        blueLabel.text = categoriesList[2]
        greenLabel.text = categoriesList[3]
    }
    
    // CLASSIFY THE WHOLE LIST INTO CATEGORIES
    // ALSO USED DURING RELOAD
    @objc func reload () {
        mainList = (user?.todoList)!
        categoriesList = (user?.categoryList)!
        redList = []
        orangeList = []
        blueList = []
        greenList = []
        redIndexList = []
        orangeIndexList = []
        blueIndexList = []
        greenIndexList = []
        var redText : String = ""
        var orangeText : String = ""
        var blueText : String = ""
        var greenText : String = ""
        for i in stride(from: 1, to: mainList.count, by: 1) {
//            let addOnText = mainList[i]
//            if mainList[i].done {
//                let attributeString : NSMutableAttributedString = NSMutableAttributedString(string: mainList[i].content!)
//                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            }
            
            switch mainList[i].category {
            case "red":
                // do red
                redList.append(mainList[i])
                redIndexList.append(i)
                redText = redText +  mainList[i].content! + "\n"
            case "orange":
                // do orange
                orangeList.append(mainList[i])
                orangeIndexList.append(i)
                orangeText = orangeText + mainList[i].content! + "\n"
            case "blue":
                // do blue
                blueList.append(mainList[i])
                blueIndexList.append(i)
                blueText = blueText + mainList[i].content! + "\n"
            case "green":
                // do green
                greenList.append(mainList[i])
                greenIndexList.append(i)
                greenText = greenText + mainList[i].content! + "\n"
            case "none":
                print()
            default: return
            }
        }
        redTextView.text = redText
        redTextView.contentOffset = .zero
        orangeTextView.text = orangeText
        orangeTextView.contentOffset = .zero
        blueTextView.text = blueText
        blueTextView.contentOffset = .zero
        greenTextView.text = greenText
        greenTextView.contentOffset = .zero
    }
}
