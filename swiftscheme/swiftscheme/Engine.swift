//
//  Engine.swift
//  slisp
//
//  Created by Sean Levin on 5/4/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public class Env {
    var contents: [Element: Element]
    
    public init() {
        self.contents = [Element: Element]()
    }
    
    public func store(key: Element, value: Element) {
        self.contents[key] = value;
    }
    
    public func lookup(key: Element) -> Element {
        if let v = self.contents[key] {
            return v
        } else {
            return Element.NilEl
        }
    }
}

public enum Element : Printable, Hashable {
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

public func runIt(code: String) -> Element {
    let env = Env()
    return eval(parse(code), env)
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
                if count(currentWord) != 0 {
                    currentList!.append(parseWord(currentWord))
                }
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

public func evalList(elements: [Element], env: Env) -> Element {
    if elements.count == 0 {
        // empty list evals as a nil
        return .NilEl
    } else {
        // eval each element
        // let evaled = elements.map({ eval($0, env) })
        let f = eval(first(elements)!, env)
        let restUneval = dropFirst(elements)
        
        // pre eval functions
        if f == .SymbolEl("if") {
            return evalIf(restUneval, env)
        } else if f == .SymbolEl("progn") {
            return evalProgn(restUneval, env)
        }
        
        // post eval functions
        let rest = restUneval.map({ eval($0, env) })
        // the first element should resolve as a method or error (need to do lookup)
        switch f {
        case .SymbolEl("+"): return reduceElements(rest, +)
        case .SymbolEl("-"): return reduceElements(rest, -)
        case .SymbolEl(">"): return evalTwo(rest, >)
        case .SymbolEl(">="): return evalTwo(rest, >=) // probably all these could be macros on < and =
        case .SymbolEl("="): return evalTwo(rest, eq)
        case .SymbolEl("<"): return evalTwo(rest, <)
        case .SymbolEl("<="): return evalTwo(rest, <=)
        case .SymbolEl("define"): return storeInEnv(rest, env)
        default: return .NilEl
        }
    }
}

public func evalProgn(elements: ArraySlice<Element>, env: Env) -> Element {
    var e: Element = .NilEl
    for (idx, val) in enumerate(elements) {
        e = eval(val, env)
    }
    // return last value
    return e
}

public func evalIf(elements: ArraySlice<Element>, env: Env)  -> Element {
    if elements.count != 3 {
        return .NilEl
    } else {
        if elements[0] == .BoolEl(true) {
            return eval(elements[1], env)
        } else if elements[0] == .BoolEl(false) {
            return eval(elements[2], env)
        } else {
            return .NilEl
        }
    }
}

public func storeInEnv(elements: ArraySlice<Element>, env: Env) -> Element {
    if elements.count == 2 {
        env.store(elements[0], value: elements[1])
        return elements[1]
    } else {
        return .NilEl
    }
}

public func evalTwo(elements: ArraySlice<Element>, reducer: (Element, Element) -> Element) -> Element {
    if elements.count == 2 {
        let e1 = elements[0]
        let e2 = elements[1]
        return reducer(e1, e2)
    } else {
        return .NilEl
    }
}

func reduceElements(elements: ArraySlice<Element>, reducer: (Element, Element) -> Element) -> Element {
    // what is no elements probably an error
    let f = first(elements)!
    let r = dropFirst(elements)
    return reduce(r, f, reducer)
}

public func eval(sexp: Element, env: Env) -> Element {
    switch sexp {
    case .ListEl(let elements): return evalList(elements, env)
    case .SymbolEl:
// could do a lookup or return self function here
// need more explaining methods
        let r = env.lookup(sexp)
        if r == .NilEl {
            return sexp
        } else {
            return r
        }
    default: return sexp
    }
}