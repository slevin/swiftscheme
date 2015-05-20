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

class slispTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOnePlusTwo() {
        let r = runIt("(+ 1 2)")
        XCTAssert(r == 3)
    }

    /*
    func testParseIntoArray() {
        let a = readFun("(+ 1 2)")
        XCTAssert(a == ["+", "1", "2"])
    }

    func testParseMultiple() {
        let a = readFun("(+ 1 2 3)")
        XCTAssertEqual(a, ["+", "1", "2", "3"])
    }
    
    func testParseIntoArrayNested() {
        let a = readFun("(+ 1 (+ 2 3)")
        XCTAssertEqual(a, ["+", "1", ["+", "2", "3"]])
    }
    */
    
    // test for extra spaces
        
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
}