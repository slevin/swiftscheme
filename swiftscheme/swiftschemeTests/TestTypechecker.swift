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
        XCTAssertFalse(t.isError)
    }
}
