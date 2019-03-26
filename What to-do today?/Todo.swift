//
//  Todo.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/23.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import Foundation
import CoreData


public class Todo: NSObject, NSCoding {
    
    var content : String!
    var category : String!
    var isToday : Bool!
    var done : Bool! = false
    
    init(content: String, category: String, isToday: Bool) {
        self.content = content
        self.category = category
        self.isToday = isToday
    }
    
    private enum Key: String {
        case content = "content"
        case category = "category"
        case isToday = "isToday"
        case done = "done"
    }
    
    public func encode(with aCoder: NSCoder) {
        if let content = self.content, let category = self.category, let isToday = self.isToday, let done = self.done
        {
            aCoder.encode(content, forKey: Key.content.rawValue)
            aCoder.encode(category, forKey: Key.category.rawValue)
            aCoder.encode(isToday, forKey: Key.isToday.rawValue)
            aCoder.encode(done, forKey: Key.done.rawValue)
        }
    }
    
    required public init?(coder aDecoder: NSCoder){
        content = aDecoder.decodeObject(forKey: Key.content.rawValue) as? String
        category = aDecoder.decodeObject(forKey: Key.category.rawValue) as? String
        isToday = aDecoder.decodeBool(forKey: Key.isToday.rawValue)
        done = aDecoder.decodeBool(forKey: Key.done.rawValue)
    }
    
}
