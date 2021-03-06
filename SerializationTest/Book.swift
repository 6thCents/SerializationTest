//
//  Book.swift
//  SerializationTest
//
//  Created by David Rollins on 11/27/15.
//  Copyright © 2015 David Rollins. All rights reserved.
//

import Foundation

class Author: NSObject, NSCoding {
    var first_name: String
    var last_name: String
    
    func fullName() -> String{
        return first_name + " " + last_name
    }
    
    init(fname: String, lname: String){
        first_name = fname
        last_name = lname
    }
    
    required convenience init?(coder decoder: NSCoder){
        guard
            let fname = decoder.decodeObjectForKey("fname") as? String,
            let lname = decoder.decodeObjectForKey("lname") as? String
        else { return nil }
        
        self.init(
            fname: fname,
            lname: lname
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.first_name, forKey: "fname")
        coder.encodeObject(self.last_name, forKey: "lname")
    }

    
}

class Book: NSObject, NSCoding {
    var title: String
    var author: Author
    var pageCount: Int
    var categories: [String]
    var available: Bool
    
    // Memberwise initializer
    init(title: String, author: Author, pageCount: Int, categories: [String], available: Bool) {
        self.title = title
        self.author = author
        self.pageCount = pageCount
        self.categories = categories
        self.available = available
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObjectForKey("title") as? String,
            let author = decoder.decodeObjectForKey("author") as? Author,
            let categories = decoder.decodeObjectForKey("categories") as? [String]
            else { return nil }
        
        self.init(
            title: title,
            author: author,
            pageCount: decoder.decodeIntegerForKey("pageCount"),
            categories: categories,
            available: decoder.decodeBoolForKey("available")
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.author, forKey: "author")
        coder.encodeInt(Int32(self.pageCount), forKey: "pageCount")
        coder.encodeObject(self.categories, forKey: "categories")
        coder.encodeBool(self.available, forKey: "available")
    }
}
