//
//  MyToDo2.swift
//  Projekt
//
//  Created by Beata Wikło on 26.05.2018.
//  Copyright © 2018 Pawel Wiklo Katarzyna Chardy. All rights reserved.
//

import Foundation
class ToDoItem2: NSObject, NSCoding
{
    var title: String
    var done: Bool
    
    
    public init(title: String)
    {
        self.title = title
        self.done = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // Try to unserialize the "title" variable
        if let title = aDecoder.decodeObject(forKey: "title") as? String
        {
            self.title = title
        }
        else
        {
            // There were no objects encoded with the key "title",
            // so that's an error.
            return nil
        }
        
        // Check if the key "done" exists, since decodeBool() always succeeds
        if aDecoder.containsValue(forKey: "done")
        {
            self.done = aDecoder.decodeBool(forKey: "done")
        }
        else
        {
            // Same problem as above
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder)
    {
        // Store the objects into the coder object
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.done, forKey: "done")
    }
}
// Creates an extension of the Collection type (aka an Array),
// but only if it is an array of ToDoItem objects.
extension Collection where Iterator.Element == ToDoItem2
{
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath(name: String) -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent(name)
        //return url?.appendingPathComponent("todoitems2.bin")
    }
    
    // Write the array to persistence
    func writeToPersistence2(name: String) throws
    {
        print("writeTo", name)
        if let url = Self.persistencePath(name: name), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo2", code: 10, userInfo: nil)
        }
    }
    
    // Read the array from persistence
    static func readFromPersistence2(name: String) throws -> [ToDoItem2]
    {
        print("readFrom", name)
        if let url = persistencePath(name: name), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDoItem2]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.MyToDo2", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo2", code: 12, userInfo: nil)
        }
    }
}
//extension ToDoItem2
//{
//    public class func getMockData() -> [ToDoItem2]
//    {
//        return [
//            ToDoItem2(title: "banany"),
//            ToDoItem2(title: "inne banany"),
//            ToDoItem2(title: "owoce"),
//            ToDoItem2(title: "jeden banan")
//        ]
//    }
//}
