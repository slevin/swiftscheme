//
//  TestEl.swift
//  swiftscheme
//
//  Created by Sean Levin on 7/14/15.
//  Copyright © 2015 Sean Levin. All rights reserved.
//

import XCTest
import swiftscheme

class TestEl: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testSymbolElsEqual() {
        XCTAssertEqual(SymbolEl("a"), SymbolEl("a"))
        
    }
}
