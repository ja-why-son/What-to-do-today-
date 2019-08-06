//
//  Todo.swift
//  What to-do today?
//
//  Created by Jayson Chen on 2019/3/23.
//  Copyright © 2019 Jayson Chen. All rights reserved.
//

import Foundation
import MobileCoreServices
import CoreData


public final class Todo: NSObject, NSCoding, Codable, NSItemProviderReading, NSItemProviderWriting {
   
    var content : String!
    var category : String!
    var isToday : Bool!
    var done : Bool! = false
    var uuid : String?
    
    init(content: String, category: String, isToday: Bool) {
        self.content = content
        self.category = category
        self.isToday = isToday
        self.uuid = UUID().uuidString
    }
    
    private enum Key: String {
        case content = "content"
        case category = "category"
        case isToday = "isToday"
        case done = "done"
        case uuid = "uuid"
    }
    
    public func encode(with aCoder: NSCoder) {
        if let content = self.content, let category = self.category, let isToday = self.isToday, let done = self.done
        {
            aCoder.encode(content, forKey: Key.content.rawValue)
            aCoder.encode(category, forKey: Key.category.rawValue)
            aCoder.encode(isToday, forKey: Key.isToday.rawValue)
            aCoder.encode(done, forKey: Key.done.rawValue)
            aCoder.encode(uuid, forKey: Key.uuid.rawValue)
        }
    }
    
    required public init?(coder aDecoder: NSCoder){
        content = aDecoder.decodeObject(forKey: Key.content.rawValue) as? String
        category = aDecoder.decodeObject(forKey: Key.category.rawValue) as? String
        isToday = aDecoder.decodeBool(forKey: Key.isToday.rawValue)
        done = aDecoder.decodeBool(forKey: Key.done.rawValue)
        uuid = aDecoder.decodeObject(forKey: Key.content.rawValue) as? String
    }
    
    public static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Todo {
        let decoder = JSONDecoder()
        do {
            let myJSON = try decoder.decode(Todo.self, from: data)
            return myJSON
        } catch {
            fatalError("Err")
        }
    }
    
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: String.Encoding.utf8)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return progress
    }
    
}
