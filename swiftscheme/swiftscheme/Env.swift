//
//  Env.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public class Env {
    var contents: [Element: Element]
    
    public init() {
        self.contents = [Element: Element]()
    }
    
    public func store(key: Element, value: Element) {
        self.contents[key] = value;
    }
    
    public func lookup(key: Element) -> Element {
        if let v = self.contents[key] {
            return v
        } else {
            return Element.NilEl
        }
    }
}

