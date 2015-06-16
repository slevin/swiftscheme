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
        } else if f == .SymbolEl("let") {
            return evalLet(restUneval, env)
        } else if f == .SymbolEl("define") {
            return storeInEnv(restUneval, env)
        } else if f == .SymbolEl("lambda") {
            return evalLambda(restUneval, env)
        }
        
        // post eval functions
        let rest = restUneval.map({ eval($0, env) })
        // the first element should resolve as a method or error (need to do lookup)
        switch f {
        case .FunEl(let funData): return evalFun(funData, rest, env)
        case .SymbolEl("recur"): return Element.RecurEl(RecurData(args:Element.ListEl(Array(rest))))
        case .SymbolEl("+"): return reduceElements(rest, +)
        case .SymbolEl("-"): return reduceElements(rest, -)
        case .SymbolEl(">"): return evalTwo(rest, >)
        case .SymbolEl(">="): return evalTwo(rest, >=) // probably all these could be macros on < and =
        case .SymbolEl("="): return evalTwo(rest, eq)
        case .SymbolEl("<"): return evalTwo(rest, <)
        case .SymbolEl("<="): return evalTwo(rest, <=)
        default: return .ErrEl("Undefined function \(f)")
        }
    }
}

public func evalFun(data: FunctionData, elements: ArraySlice<Element>, env: Env) -> Element {
    var letArgs = [Element]()
    var argList = [Element]()
    
    switch data.args {
    case .ListEl(let argElements):
        if (argElements.count != elements.count) {
            return .ErrEl("Parameter count and argument count do not match. Should be \(argElements.count)")
        }
        for (i, e) in EnumerateSequence(argElements) {
            argList.append(Element.ListEl([e, elements[i]]))
        }
    default:
        break
    }
    letArgs.append(.ListEl(argList))
    letArgs.append(data.body)
    let slice = ArraySlice<Element>(letArgs)
    let result = evalLet(slice, env)
    return result
}


public func evalLambda(elements: ArraySlice<Element>, env: Env) -> Element {
    if elements.count != 2 {
        return .ErrEl("lambda takes two parameters, you passed \(elements)")
    }
    
    let args = elements[0]
    switch args {
    case .ListEl:
        return .FunEl(FunctionData(body:elements[1], args:args))
    default:
        return .ErrEl("First argument of lambda must be a list element \(elements)")
    }
}

public func evalLet(elements: ArraySlice<Element>, env: Env) -> Element {
    // redefine let as a progn of defines and the final function
    if elements.count == 2 {
        let newEnv = Env(parent: env)
        var rewritten: [Element] = [Element]()
        rewritten.append(.SymbolEl("progn"))
        switch elements[0] {
        case .ListEl(let defines):
            for def in defines {
                switch def {
                case .ListEl(let pair):
                    if pair.count == 2 {
                        rewritten.append(.ListEl([.SymbolEl("define"), pair[0], pair[1]]))
                    } else {
                        return .NilEl // each subparam must be pair
                    }
                default: return .NilEl // each subparam must be list
                }
            }
        default: return .NilEl // first param must be list
        }
        rewritten.append(elements[1])
        return eval(.ListEl(rewritten), newEnv) // eval new built list
    } else {
        return .NilEl // invalid let params
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
        return .ErrEl("if function requires 3 arguments.")
    } else {
        let res = eval(elements[0], env)
        if res == .BoolEl(true) {
            return eval(elements[1], env)
        } else if res == .BoolEl(false) {
            return eval(elements[2], env)
        } else {
            return .ErrEl("First argument to if must be boolean.")
        }
    }
}

public func storeInEnv(elements: ArraySlice<Element>, env: Env) -> Element {
    if elements.count == 2 {
        env.store(elements[0], value: eval(elements[1], env))
        return elements[1]
    } else {
        return .ErrEl("Define requires two arguments.")
    }
}

public func evalTwo(elements: ArraySlice<Element>, reducer: (Element, Element) -> Element) -> Element {
    if elements.count == 2 {
        let e1 = elements[0]
        let e2 = elements[1]
        return reducer(e1, e2)
    } else {
        return .ErrEl("Two arguments required.")
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