//
//  Element.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public enum Element : Printable, Hashable, DebugPrintable {
    case SymbolEl(String)
    case IntEl(Int)
    case BoolEl(Bool)
    case ListEl([Element])
    case NilEl
    
    public var description : String {
        switch self {
        case .SymbolEl(let s): return "Symbol: \(s)"
        case .IntEl(let s): return "Int: \(s)"
        case .ListEl(let s):
            if s.count == 0 {
                return "[]"
            } else {
                let fst = first(s)!
                let rst = dropFirst(s)
                let els = rst.reduce(fst.description, combine: { (s1: String, s2: Element) -> String in
                    return s1 + ", " + s2.description
                })
                return "[\(els)]"
            }
        case .NilEl: return "Nil"
        case .BoolEl(let s): return s ? "#t" : "#f"
        }
    }
    
    public var debugDescription: String { return self.description }
    
    public var hashValue: Int { return self.description.hashValue }
}

public func ==(a: Element, b: Element) -> Bool {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return a == b
    case (.SymbolEl(let a), .SymbolEl(let b)): return a == b
    case (.ListEl(let a), .ListEl(let b)): return a == b
    case (.BoolEl(let a), .BoolEl(let b)): return a == b
    case (.NilEl, .NilEl): return true
    default: return false
    }
}

public func +(a: Element, b: Element) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .IntEl(a + b)
    default: return .NilEl
    }
}

public func -(a: Element, b: Element) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .IntEl(a - b)
    default: return .NilEl
    }
}

public func intCompare(a: Element, b: Element, comp: (Int, Int) -> Bool) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .BoolEl(comp(a, b))
    default: return .NilEl
    }
}

public func >(a: Element, b: Element) -> Element {
    return intCompare(a, b, >)
}

public func >=(a: Element, b: Element) -> Element {
    return intCompare(a, b, >=)
}

public func eq(a: Element, b: Element) -> Element {
    return Element.BoolEl(a == b)
}

public func <(a: Element, b: Element) -> Element {
    return intCompare(a, b, <)
}

public func <=(a: Element, b: Element) -> Element {
    return intCompare(a, b, <=)
}

