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

class EnvTests: XCTestCase {
    typealias E = Element
    
    func testAddLookup() {
        let e = Env()
        e.store(E.SymbolEl("a"), value: E.IntEl(1))
        let el = e.lookup(.SymbolEl("a"))
        XCTAssertEqual(E.IntEl(1), el)
    }
    
    func testNotFound() {
        let e = Env()
        e.store(Element.SymbolEl("a"), value: Element.IntEl(1))
        let el = e.lookup(.SymbolEl("b"))
        XCTAssertEqual(E.NilEl, el)
    }

    func testLookup() {
        let p = parse("(+ a b)")
        let e = Env()
        e.store(E.SymbolEl("a"), value: Element.IntEl(1))
        e.store(E.SymbolEl("b"), value: Element.IntEl(2))
        let r = eval(p, e)
        XCTAssertEqual(E.IntEl(3), r)
    }
    
    func testDefine() {
        let e = Env()
        let r = eval(parse("(define a 1)"), e)
        let stored = e.lookup(E.SymbolEl("a"))
        XCTAssertEqual(E.IntEl(1), stored)
    }

    func testNestedEnvs() {
        // value defined in parent is visible
        let e1 = Env()
        e1.store(E.SymbolEl("a"), value: E.IntEl(1))
        let e2 = Env(parent: e1)
        let r = eval(parse("(+ a 2)"), e2)
        XCTAssertEqual(E.IntEl(3), r)
    }
    
    // should check define against non symbol parameter
    // whats the point in storing an int to an int when
    // I only check against the symbol
    
    
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
    
    func testParseBoolFalse() {
        let e = parseWord("#f")
        XCTAssertEqual(E.BoolEl(false), e)
    }

    func testParseBoolTrue() {
        let e = parseWord("#t")
        XCTAssertEqual(E.BoolEl(true), e)
    }

    func testParseSimpleCode() {
        let e = parse("(+ 1 2)")
        XCTAssertEqual(E.ListEl([E.SymbolEl("+"), E.IntEl(1), E.IntEl(2)]), e)
    }

    func testParseAfterList() {
        let e = parse("(a (b c d) e)")
        XCTAssertEqual(E.ListEl([E.SymbolEl("a"), E.ListEl([E.SymbolEl("b"),
            E.SymbolEl("c"), E.SymbolEl("d")]), E.SymbolEl("e")]), e)
    }
    func testParseNeseted() {
        let e = parse("(+ 1 (+ 2 3))")
        XCTAssertEqual(E.ListEl([E.SymbolEl("+"),
            E.IntEl(1),
            E.ListEl([E.SymbolEl("+"),
                E.IntEl(2),
                E.IntEl(3)])]), e)
    }

    func testParseEmptyList() {
        let e = parse("()")
        XCTAssertEqual(E.ListEl([]), e)
    }
    // test for extra spaces

    // test longer words and error cases
    
    // (...)3) probably shouldn't work but probably does
}
