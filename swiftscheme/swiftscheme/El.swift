//
//  El.swift
//  swiftscheme
//
//  Created by Sean Levin on 7/14/15.
//  Copyright © 2015 Sean Levin. All rights reserved.
//

import Foundation

protocol El: Equatable {
    
}

public func ==(lhs: SymbolEl, rhs: SymbolEl) -> Bool {
    return lhs.rep == rhs.rep
}

public struct SymbolEl: Equatable {
    var rep : String
    
    public init(_ rep: String) {
        self.rep = rep
    }
    
}

/*
public struct ListEl {
    var elements : [El]
}
*/