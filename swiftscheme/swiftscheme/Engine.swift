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
    var listStack:[[String]] = [[String]]()
    var currentList:[String]?
    var currentWord = ""
    for c in code {
        if (c == "(") {
            /*

            when ) append current and if there is something on listStack
             add current to whats on top and make current the top
*/
            // if there is a current list push it on the stack
            if currentList != nil {
                listStack.append(currentList!)
            }
            // make a new list to build
            currentList = [String]()
            
        } else if (c == " ") {
            if currentList != nil {
                currentList!.append(currentWord)
            }
            currentWord = ""
        } else if (c == ")") {
            if currentList != nil {
                currentList!.append(currentWord)
                // if theres a stack of lists
                if listStack.count > 0 {
                    // pop the top, add current to that
                    var popped = listStack.removeLast()
                    popped.append(currentList!)
                    // and make the top the current
                }
            }

            break;
        } else {
            currentWord.append(c)
        }
    }
    return currentList ?? [String]()
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