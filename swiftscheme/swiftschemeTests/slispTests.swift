//
//  slispTests.swift
//  slispTests
//
//  Created by Sean Levin on 5/4/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Cocoa
import XCTest
import swiftscheme

class ElementTests: XCTestCase {
    typealias E = Element
    
    func testIntElsEqual() {
        XCTAssertEqual(Element.IntEl(1), Element.IntEl(1))
    }
    
    func testDifferentIntElsNotEqual() {
        XCTAssertNotEqual(Element.IntEl(2), Element.IntEl(1))
    }
    
    func testSymbolElsEqual() {
        XCTAssertEqual(Element.SymbolEl("a"), Element.SymbolEl("a"))
    }
    
    func testDifferentSymbolElsNotEqual() {
        XCTAssertNotEqual(E.SymbolEl("a"), E.SymbolEl("b"))
    }
    
    func testLestElsEqual() {
        XCTAssertEqual(E.ListEl([E.IntEl(1), E.SymbolEl("a")]), E.ListEl([.IntEl(1), E.SymbolEl("a")]))
    }
    
    func testNestedListElsEqual() {
        XCTAssertEqual(E.ListEl([E.ListEl([E.IntEl(1)])]), E.ListEl([E.ListEl([E.IntEl(1)])]))
    }
    
    func testDifferentListElsNotEqual() {
        XCTAssertNotEqual(E.ListEl([E.IntEl(1), E.SymbolEl("a")]), E.ListEl([.IntEl(1), E.SymbolEl("b")]))
    }
}

class ParsingTests: XCTestCase {
    typealias E = Element
    
    func testParseInt() {
        let e = parseWord("1")
        XCTAssertEqual(E.IntEl(1), e)
    }
    
    func testParseSymbol() {
        let e = parseWord("seanrules")
        XCTAssertEqual(E.SymbolEl("seanrules"), e)
    }
    
    func testParseSimpleCode() {
        let e = parse("(+ 1 2)")
        XCTAssertEqual(E.ListEl([E.SymbolEl("+"), E.IntEl(1), E.IntEl(2)]), e)
    }

    func testParseNeseted() {
        let e = parse("(+ 1 (+ 2 3))")
        XCTAssertEqual(E.ListEl([E.SymbolEl("+"),
            E.IntEl(1),
            E.ListEl([E.SymbolEl("+"),
                E.IntEl(2),
                E.IntEl(3)])]), e)
    }

    // test for extra spaces

    // test longer words and error cases
    
}

class EvalTests: XCTestCase {
    typealias E = Element

    /*
    
    
    func testPlusEval() {
    let s:[Atom] = [.StringAtom("+"), .IntAtom(1), .IntAtom(2)]
    let e = eval(s)
    XCTAssertEqual(e, .IntAtom(3))
    }
    
    func testPlusEvalMultiple() {
    let s:[Atom] = [.StringAtom("+"), .IntAtom(1), .IntAtom(2), .IntAtom(1)]
    let e = eval(s)
    XCTAssertEqual(e, .IntAtom(4))
    }
    
    func testMinusEval() {
    let s:[Atom] = [.StringAtom("-"), .IntAtom(1), .IntAtom(2)]
    let e = eval(s)
    XCTAssertEqual(e, .IntAtom(-1))
    }
    */
    
}