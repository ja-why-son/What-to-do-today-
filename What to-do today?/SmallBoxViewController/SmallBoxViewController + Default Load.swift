//
//  SmallBoxViewController + Default Load.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/7/30.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import UIKit

extension SmallBoxViewController {
    
    func createTips() -> [Todo] {
        return [
            Todo(content: "Long press and drag a todo to re-arrange it.", category: "red", isToday: false),
            Todo(content: "Break down big todos into smaller ones", category: "red", isToday: false),
        ]
    }
    
//    func createInstruction() -> [Todo] {
//        let upperLeft = [Todo(content: "Jot down your tasks here", category: "red", isToday: false),
//                         Todo(content: "Check them off when you're done", category: "red", isToday: false),
//                         Todo(content: "Swipe RIGHT to add to \"Today\" page", category: "red", isToday: false),
//                         Todo(content: "Swipe LEFT to delete todo", category: "red", isToday: false),
//                         Todo(content: "Long press to re-arrange todos", category: "red", isToday: false),
//                         Todo(content: "Tap the title to edit", category: "red", isToday: false)];
//        let upperRight = [Todo(content: "Exit this box and swipe towards RIGHT to get to \"Today\" page", category: "orange", isToday: false),
//                          Todo(content: "Exit the box and swipe left to TODAY", category: "orange", isToday: false),
//                          Todo(content: "All the todos you should finish today are over there!", category: "orange", isToday: false)]
//        let bottomLeft = [Todo(content: "Plan out your tasks today", category: "blue", isToday: false),
//                          Todo(content: "Organize your to-do lists", category: "blue", isToday: false),
//                          Todo(content: "Click the button in the upper right to clear your done todos", category: "blue", isToday: true)]
//        let bottomRight = [Todo(content: "If you like this app, make sure to rate us on the app store", category: "green", isToday: false),Todo(content: "Happy productivity!", category: "green", isToday: true)]
//        return upperLeft + upperRight + bottomLeft + bottomRight
//    }
}
