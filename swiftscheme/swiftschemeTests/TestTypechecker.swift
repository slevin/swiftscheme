//
//  TestTypechecker.swift
//  swiftscheme
//
//  Created by Sean Levin on 7/6/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Cocoa
import XCTest
import swiftscheme

class TestTypechecker: XCTestCase {
    typealias E = Element
    typealias T = TypecheckResult
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddChecks() {
        let t = typecheckIt("(+ 1 2)")
        XCTAssertEqual(t, T.Success)
    }
    
    /*
    func testAddNotCheck() {
        // plus supports only all the same
        // arguments and must all be int or float
        // result can be fail or it can be fail with description of some sort
        let t = typecheckIt("(+ 1 #f)")
        XCTAssertEqual(t, T.Failure)
    }
*/
}
