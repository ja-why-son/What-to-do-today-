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
        let redText : NSMutableAttributedString = NSMutableAttributedString()
        let orangeText : NSMutableAttributedString = NSMutableAttributedString()
        let blueText : NSMutableAttributedString = NSMutableAttributedString()
        let greenText : NSMutableAttributedString = NSMutableAttributedString()
        let paragraphstyle = NSMutableParagraphStyle()
        paragraphstyle.paragraphSpacingBefore = 5
        paragraphstyle.paragraphSpacing = 3
        let attributes: [NSAttributedString.Key : Any] = [
            .font: redTextView.font!,
            .paragraphStyle: paragraphstyle,
        ]
        for i in stride(from: 0, to: mainList.count, by: 1) {
            var addOnText : NSMutableAttributedString
            addOnText = NSMutableAttributedString(string: mainList[i].content!)
            if mainList[i].done {
                addOnText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, addOnText.length))
            }
            switch mainList[i].category {
            case "red":
                // do red
                redList.append(mainList[i])
                redIndexList.append(i)
                redText.append(addOnText)
                redText.append(NSAttributedString(string: "\n"))
            case "orange":
                // do orange
                orangeList.append(mainList[i])
                orangeIndexList.append(i)
                orangeText.append(addOnText)
                orangeText.append(NSAttributedString(string: "\n"))
            case "blue":
                // do blue
                blueList.append(mainList[i])
                blueIndexList.append(i)
                blueText.append(addOnText)
                blueText.append(NSAttributedString(string: "\n"))
            case "green":
                // do green
                greenList.append(mainList[i])
                greenIndexList.append(i)
                greenText.append(addOnText)
                greenText.append(NSAttributedString(string: "\n"))
            case "none":
                print()
            default: return
            }
        }
        redText.addAttributes(attributes, range: NSMakeRange(0, redText.length))
        redTextView.attributedText = redText
        redTextView.contentOffset = .zero
        
        orangeText.addAttributes(attributes, range: NSMakeRange(0, orangeText.length))
        orangeTextView.attributedText = orangeText
        orangeTextView.contentOffset = .zero
        
        blueText.addAttributes(attributes, range: NSMakeRange(0, blueText.length))
        blueTextView.attributedText = blueText
        blueTextView.contentOffset = .zero
        
        greenText.addAttributes(attributes, range: NSMakeRange(0, greenText.length))
        greenTextView.attributedText = greenText
        greenTextView.contentOffset = .zero
    }
}
