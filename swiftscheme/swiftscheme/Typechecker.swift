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
    return .Success
}