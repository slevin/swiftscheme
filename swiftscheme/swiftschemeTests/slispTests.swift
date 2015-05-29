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
    
    func testBoolElsEqual() {
        XCTAssertEqual(E.BoolEl(true), E.BoolEl(true))
    }

    func testDifferentBoolElsNotEqual() {
        XCTAssertNotEqual(E.BoolEl(true), E.BoolEl(false))
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
    
    func testNilEqual() {
        XCTAssertEqual(E.NilEl, E.NilEl)
    }
}

class EnvTests: XCTestCase {
    typealias E = Element
    
    func testAddLookup() {
        let e = Env()
        e.store(E.SymbolEl("a"), val: E.IntEl(1))
        let el = e.lookup(.SymbolEl("a"))
        XCTAssertEqual(E.IntEl(1), el)
    }
    
    func testNotFound() {
        let e = Env()
        e.store(Element.SymbolEl("a"), val: Element.IntEl(1))
        let el = e.lookup(.SymbolEl("b"))
        XCTAssertEqual(E.NilEl, el)
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

class EvalTests: XCTestCase {
    typealias E = Element

    func testPlusEval() {
        let r = runIt("(+ 1 2)")
        XCTAssertEqual(E.IntEl(3), r)
    }
    
    func testPlusMultipleEval() {
        let r = runIt("(+ 1 2 3)")
        XCTAssertEqual(E.IntEl(6), r)
    }
    
    func testPlusNested() {
        let r = runIt("(+ 1 (+ 2 3))")
        XCTAssertEqual(E.IntEl(6), r)
    }
    
    func testMinusEval() {
        let r = runIt("(- 1 2)")
        XCTAssertEqual(E.IntEl(-1), r)
    }
    
    func testMixed() {
        let r = runIt("(- 1 (+ 3 4))")
        XCTAssertEqual(E.IntEl(-6), r)
    }

    func testGT() {
        let r = runIt("(> 4 3)")
        XCTAssertEqual(E.BoolEl(true), r)
    }
    
    func testGTE() {
        let r = runIt("(>= 4 4)")
        XCTAssertEqual(E.BoolEl(true), r);
    }
    
    func testEq() {
        let r = runIt("(= 4 4)")
        XCTAssertEqual(E.BoolEl(true), r)
    }
    
    func testLT() {
        let r = runIt("(< 4 3)")
        XCTAssertEqual(E.BoolEl(false), r)
    }
    
    func testLTE() {
        let r = runIt("(<= 4 4)")
        XCTAssertEqual(E.BoolEl(true), r)
    }

}