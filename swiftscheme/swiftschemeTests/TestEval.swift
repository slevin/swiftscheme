//
//  TestEval.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Cocoa
import XCTest
import swiftscheme

class TestEval: XCTestCase {

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
    
    func testIfTrue() {
        let r = runIt("(if #t (+ 1 3) (+ 1 4))")
        XCTAssertEqual(E.IntEl(4), r)
    }
    
    func testIfFalse() {
        let r = runIt("(if #f (+ 1 3) (+ 1 4))")
        XCTAssertEqual(E.IntEl(5), r)
    }
    
    func testProgn() {
        // multiline statements
        let r = runIt("(progn (define a 3) (+ 1 a))")
        XCTAssertEqual(E.IntEl(4), r)
    }
    
    func testPrognMulti() {
        let r = runIt("(progn (define a 3) (+ 1 a) (+ 5 6))")
        XCTAssertEqual(E.IntEl(11), r)
    }

}
