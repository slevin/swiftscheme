//
//  Typechecker.swift
//  swiftscheme
//
//  Created by Sean Levin on 7/6/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public enum TypecheckResult {
    case Success
    case Failure
}

public func typecheckIt(code: String) -> TypecheckResult {
    return typecheck(parse(code))
}

public func typecheck(el: Element) -> TypecheckResult  {
    switch el {
    case .ListEl(let elements): return typecheckList(elements)
    default: return .Failure
    }
}

public func typecheckList(elements: [Element]) -> TypecheckResult {
    let f = elements.first!
    let rest = dropFirst(elements)
    
    if f == .SymbolEl("+") {
        let twoOrMoreArgs = rest.count >= 2
        if !twoOrMoreArgs { return .Failure }
        
        var firstIsNumeric = false
        switch rest[0] {
        case .IntEl, .DoubleEl: firstIsNumeric = true
        default: firstIsNumeric = false
        }
        if !firstIsNumeric { return .Failure }
        
        var allSameType = false
        // if no previous type then save previous type
        // otherwise if different allsametype is false break
        // otherwise allsametype = true
        // this is a problem since I don't know how to compare "types"
        // as they are just values which I can check with switch
        return .Success
    } else {
        return .Failure
    }
}

// if its a plus then we make sure that all elements are the same type
// and that type is int or double
