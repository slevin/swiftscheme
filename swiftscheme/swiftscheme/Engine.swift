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


public enum Element : Equatable, Printable {
    case SymbolEl(String)
    case IntEl(Int)
    case ListEl([Element])
    case NilEl
    
    public var description : String {
        switch self {
        case .SymbolEl(let s): return "Symbol: \(s)"
        case .IntEl(let s): return "Int: \(s)"
        case .ListEl(let s):
            let els = s.reduce("", combine: { (s1: String, s2: Element) -> String in
                return s1 + ", " + s2.description
            })
            return "[\(els)]"
        case .NilEl: return "Nil"
        }
    }
}

public func ==(a: Element, b: Element) -> Bool {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return a == b
    case (.SymbolEl(let a), .SymbolEl(let b)): return a == b
    case (.ListEl(let a), .ListEl(let b)): return a == b
    default: return false
    }
}


public func runIt(code: String) -> Int {
    return 3
}

public func parseWord(word: String) -> Element {
    // try to parse as a number if that isn't anything
    if let i = word.toInt() {
        return .IntEl(i)
    } else {
        return .SymbolEl(word)
    }
}

public func parse(code: String) -> Element {
    var listStack:[[Element]] = [[Element]]()
    var currentList:[Element]?
    var currentWord = ""
    for c in code {
        if (c == "(") {
            // if there is a current list push it on the stack
            if currentList != nil {
                listStack.append(currentList!)
            }
            // make a new list to build
            currentList = [Element]()
            
        } else if (c == " ") {
            // duplication with below, whats in common?
            if currentList != nil {
                currentList!.append(parseWord(currentWord))
            }
            currentWord = ""
        } else if (c == ")") {
            if currentList != nil {
                // add the current word if something is being worked on
                if count(currentWord) != 0 {
                    currentList!.append(parseWord(currentWord))
                    currentWord = ""
                }
                // if theres a stack of lists
                if listStack.count > 0 {
                    // pop the top, add current to that
                    var popped:[Element] = listStack.removeLast()
                    popped.append(Element.ListEl(currentList!))
                    // and make the top the current
                    currentList = popped
                } else {
                    // otherwise we are done with last list
                    return Element.ListEl(currentList!)
                }
            } else {
                return Element.NilEl
            }
        } else {
            currentWord.append(c)
        }
    }
    // if we got here its malformed
    // unclosed list or no list at all
    return Element.NilEl
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