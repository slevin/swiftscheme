//
//  Engine.swift
//  slisp
//
//  Created by Sean Levin on 5/4/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public func runIt(code: String) -> Element {
    let env = Env()
    return eval(parse(code), env)
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