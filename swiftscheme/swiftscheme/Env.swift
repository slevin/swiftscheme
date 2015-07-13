//
//  Env.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public class Env: CustomStringConvertible {
    var contents: [Element: Element]
    var parent: Env?
    
    public init() {
        self.contents = [Element: Element]()
    }

    public init(parent: Env) {
        self.contents = [Element: Element]()
        self.parent = parent
    }
    
    public func store(key: Element, value: Element) {
        self.contents[key] = value;
    }
    
    public func lookup(key: Element) -> Element {
        if let v = self.contents[key] {
            return v
        } else if self.parent != nil {
            return self.parent!.lookup(key)
        } else {
            return Element.NilEl
        }
    }
    
    public var description : String {
        var parentString = "None"
        if self.parent != nil {
            parentString = "\(self.parent!.description)"
        }
        return "Contents: \(self.contents.description)\nParent: \(parentString)"
    }
}

