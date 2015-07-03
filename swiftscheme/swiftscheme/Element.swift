//
//  Element.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public class FunctionData : Printable, Equatable {
    // class instead of struct to allow recursive enums

    public var body: Element
    public var args: Element // list element
    
    public init(body: Element, args: Element) {
        self.body = body
        self.args = args
    }
    
    public var description : String {
        return "args:\(args); body:\(body)"
    }
}

public func ==(a: FunctionData, b: FunctionData) -> Bool {
    return a.body == b.body && a.args == b.args
}


public class RecurData : Printable, Equatable {
    // class instead of struct to allow recursive enums
    
    public var args: Element // list element
    
    public init(args: Element) {
        self.args = args
    }
    
    public var description : String {
        return "args:\(args)"
    }
}

public func ==(a: RecurData, b: RecurData) -> Bool {
    return a.args == b.args
}

public enum Element : Printable, Hashable, DebugPrintable {
    case SymbolEl(String)
    case IntEl(Int)
    case DoubleEl(Double)
    case BoolEl(Bool)
    case ListEl([Element])
    case ErrEl(String)
    case FunEl(FunctionData)
    case RecurEl(RecurData)
    case NilEl
    
    public var description : String {
        switch self {
        case .SymbolEl(let s): return "Symbol: \(s)"
        case .IntEl(let s): return "Int: \(s)"
        case .DoubleEl(let s): return "Double: \(s)"
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
        case .ErrEl(let s): return "Error: \(s)"
        case .FunEl(let s): return "Fun(\(s))"
        case .RecurEl(let s): return "Recur(\(s)"
        }
    }
    
    public var debugDescription: String { return self.description }
    
    public var hashValue: Int { return self.description.hashValue }
    
    public var isError: Bool {
        switch self {
        case .ErrEl: return true
        default: return false
        }
    }
    
    public var isFun: Bool {
        switch self {
        case .FunEl: return true
        default: return false
        }
    }
    
    public var isList: Bool {
        switch self {
        case .ListEl: return true
        default: return false
        }
    }
    
    public var isRecur: Bool {
        switch self {
        case .RecurEl: return true
        default: return false
        }
    }
}

public func ==(a: Element, b: Element) -> Bool {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return a == b
    case (.DoubleEl(let a), .DoubleEl(let b)): return a == b
    case (.SymbolEl(let a), .SymbolEl(let b)): return a == b
    case (.ListEl(let a), .ListEl(let b)): return a == b
    case (.BoolEl(let a), .BoolEl(let b)): return a == b
    case (.NilEl, .NilEl): return true
    case (.FunEl(let a), .FunEl(let b)): return a == b
    case (.RecurEl(let a), .RecurEl(let b)): return a == b
    default: return false
    }
}

public func +(a: Element, b: Element) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .IntEl(a + b)
    default: return .ErrEl("Cannot apply \"+\" to \(a) and \(b)")
    }
}

public func -(a: Element, b: Element) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .IntEl(a - b)
    default: return .ErrEl("Cannot apply \"-\" to \(a) and \(b)")
    }
}

public func *(a: Element, b: Element) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .IntEl(a * b)
    default: return .ErrEl("Cannot apply \"*\" to \(a) and \(b)")
    }
}
public func intCompare(a: Element, b: Element, comp: (Int, Int) -> Bool) -> Element {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return .BoolEl(comp(a, b))
    default: return .ErrEl("Cannot compare \(a) to \(b)")
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

