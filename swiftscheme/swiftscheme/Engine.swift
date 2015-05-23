//
//  Engine.swift
//  slisp
//
//  Created by Sean Levin on 5/4/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public enum Element : Equatable, Printable {
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
            let els = s.reduce("", combine: { (s1: String, s2: Element) -> String in
                return s1 + ", " + s2.description
            })
            return "[\(els)]"
        case .NilEl: return "Nil"
        case .BoolEl(let s): return s ? "#t" : "#f"
        }
    }
}

public func ==(a: Element, b: Element) -> Bool {
    switch (a, b) {
    case (.IntEl(let a), .IntEl(let b)): return a == b
    case (.SymbolEl(let a), .SymbolEl(let b)): return a == b
    case (.ListEl(let a), .ListEl(let b)): return a == b
    case (.BoolEl(let a), .BoolEl(let b)): return a == b
    default: return false
    }
}


public func runIt(code: String) -> Element {
    return eval(parse(code))
}

public func parseWord(word: String) -> Element {
    // try to parse as a number if that isn't anything
    if word == "#f" {
        return .BoolEl(false)
    } else if word == "#t" {
        return .BoolEl(true)
    } else if let i = word.toInt() {
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

public func evalList(elements: [Element]) -> Element {
    if elements.count == 0 {
        // empty list evals as a nil
        return .NilEl
    } else {
        // eval each element
        let evaled = elements.map({ eval($0) })
        let f = first(evaled)!
        let rest = dropFirst(evaled)
        // the first element should resolve as a method or error (need to do lookup)
        switch f {
        case .SymbolEl("+"): return plusElements(rest)
        case .SymbolEl("-"): return minusElements(rest)
        default: return .NilEl // probably should be an error of some sort
        }
    }
}

func plusElements(elements: ArraySlice<Element>) -> Element {
    // what is no elements probably an error
    let f = first(elements)!
    let r = dropFirst(elements)
    return reduce(r, f, { (a: Element, b: Element) -> Element in
        switch (a, b) {
        case (.IntEl(let a), .IntEl(let b)) : return .IntEl(a + b)
        default: return .NilEl
        }
    })
}

func minusElements(elements: ArraySlice<Element>) -> Element {
    // what is no elements probably an error
    let f = first(elements)!
    let r = dropFirst(elements)
    return reduce(r, f, { (a: Element, b: Element) -> Element in
        switch (a, b) {
        case (.IntEl(let a), .IntEl(let b)) : return .IntEl(a - b)
        default: return .NilEl
        }
    })
}

public func eval(sexp: Element) -> Element {
    switch sexp {
    case .ListEl(let elements): return evalList(elements)
    default: return sexp
    }
}