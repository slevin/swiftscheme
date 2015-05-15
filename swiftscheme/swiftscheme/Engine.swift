//
//  Engine.swift
//  slisp
//
//  Created by Sean Levin on 5/4/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public enum Atom : Equatable, Printable {
    case StringAtom(String)
    case IntAtom(Int)
    
    public var description : String {
        switch self {
        case .StringAtom(let s): return "StringAtom: \(s)"
        case .IntAtom(let i): return "IntAtom: \(i)"
        }
    }
}

public func ==(a: Atom, b: Atom) -> Bool {
    switch (a, b) {
    case (.IntAtom(let a), .IntAtom(let b)) where a == b: return true
    default: return false
    }
}



public func runIt(code: String) -> Int {
    return 3
}

public func readFun(code: String) -> [String] {
    var res:[String] = [String]()
    var current = ""
    for c in code {
        if (c == "(") {
            res = [String]()
        } else if (c == " ") {
            res.append(current)
            current = ""
        } else if (c == ")") {
            res.append(current)
            break;
        } else {
            current.append(c)
        }
    }
    return res
}

public func eval(sexp: [Atom]) -> Atom {
    let f:Atom = first(sexp)!
    let r = dropFirst(sexp)
    switch (f) {
    case .StringAtom(let s) :
        switch (s) {
        case "+" :
            return reduce(r, Atom.IntAtom(0), { (a: Atom, b: Atom) -> Atom in
                switch (a, b) {
                case (.IntAtom(let a), .IntAtom(let b)) : return .IntAtom(a + b)
                default: return Atom.IntAtom(0)
                }
            })
        case "-" :
            return reduce(dropFirst(r), first(r)!, { (a: Atom, b: Atom) -> Atom in
                switch (a, b) {
                case (.IntAtom(let a), .IntAtom(let b)) : return .IntAtom(a - b)
                default: return Atom.IntAtom(0)
                }
            })
        default :
            return Atom.IntAtom(0)
        }
    default:
        return Atom.IntAtom(0)
    }
}