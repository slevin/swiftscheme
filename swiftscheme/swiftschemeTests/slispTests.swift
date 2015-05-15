//
//  slispTests.swift
//  slispTests
//
//  Created by Sean Levin on 5/4/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Cocoa
import XCTest
import slisp

class atomTests: XCTestCase {

    func testIntAtomsEqual() {
        XCTAssertEqual(Atom.IntAtom(0), Atom.IntAtom(0))
    }

    func testDifferentIntAtomsNotEqual() {
        XCTAssertNotEqual(Atom.IntAtom(0), Atom.IntAtom(1))
    }

    func testDifferentAtomTypesNotEqual() {
        XCTAssertNotEqual(Atom.StringAtom("hello"), Atom.IntAtom(1))
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

    func testParseIntoArray() {
        let a = readFun("(+ 1 2)")
        XCTAssert(a == ["+", "1", "2"])
    }

    func testParseIntoArrayNested() {
        let a = readFun("(+ 1 (+ 2 3)")
        XCTAssertEqual(a, ["+", "1", ["+", "2", "3"]])
    }
    
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