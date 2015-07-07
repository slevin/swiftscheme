//
//  Typechecker.swift
//  swiftscheme
//
//  Created by Sean Levin on 7/6/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public func typecheckIt(code: String) -> Element {
    return typecheck(parse(code))
}

public func typecheck(el: Element) -> Element {
    return .BoolEl(true)
}