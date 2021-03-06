//
//  TestElement.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/4/15.
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
    
    func testDoubleElsEqual() {
        XCTAssertEqual(Element.DoubleEl(1.5), Element.DoubleEl(1.5))
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
    
    func testListElsEqual() {
        XCTAssertEqual(E.ListEl([E.IntEl(1), E.SymbolEl("a")]), E.ListEl([.IntEl(1), E.SymbolEl("a")]))
    }
    
    func testNestedListElsEqual() {
        XCTAssertEqual(E.ListEl([E.ListEl([E.IntEl(1)])]), E.ListEl([E.ListEl([E.IntEl(1)])]))
    }
    
    func testDifferentListElsNotEqual() {
        XCTAssertNotEqual(E.ListEl([E.IntEl(1), E.SymbolEl("a")]), E.ListEl([.IntEl(1), E.SymbolEl("b")]))
    }
    
    func testListIsList() {
        XCTAssertTrue(E.ListEl([E.IntEl(1)]).isList)
    }
    
    func testNotListIsntList() {
        XCTAssertFalse(E.IntEl(1).isList)
    }
    
    func testNilEqual() {
        XCTAssertEqual(E.NilEl, E.NilEl)
    }
    
    func testListPrintsNicely() {
        XCTAssertEqual(E.ListEl([E.IntEl(1), E.IntEl(2)]).description, "[\(E.IntEl(1)), \(E.IntEl(2))]")
    }
    
    func testErrorIsError() {
        XCTAssertTrue(E.ErrEl("err").isError)
    }
    
    func testIntIsNotError() {
        XCTAssertFalse(E.IntEl(1).isError)
    }

    func testAddWorks() {
        XCTAssertEqual(E.IntEl(1) + E.IntEl(1), E.IntEl(2))
    }
    
    func testAddWrongTypesIsError() {
        XCTAssert((E.IntEl(1) + E.SymbolEl("a")).isError)
    }
    
    func testMinusWorks() {
        XCTAssertEqual(E.IntEl(1) - E.IntEl(2), E.IntEl(-1))
    }
    
    func testMinusWrongTypesIsError() {
        XCTAssertTrue((E.SymbolEl("a") - E.SymbolEl("b")).isError)
    }
    
    func testCompareWrongTypesIsError() {
        XCTAssertTrue((E.SymbolEl("a") > E.IntEl(5)).isError)
    }

    func testFunTypesEqual() {
        XCTAssertEqual(E.FunEl(FunctionData(body: E.IntEl(1), args:E.ListEl([E.SymbolEl("a")]))),
                       E.FunEl(FunctionData(body: E.IntEl(1), args:E.ListEl([E.SymbolEl("a")]))))
    }
    
    func testFunTypesNotEqual() {
        XCTAssertNotEqual(E.FunEl(FunctionData(body: E.IntEl(1), args: E.ListEl([]))), E.FunEl(FunctionData(body: E.ListEl([E.IntEl(1)]), args: E.ListEl([]))))
    }
    
    func testRecurType() {
        XCTAssertTrue(E.RecurEl(RecurData(args:E.ListEl([]))).isRecur)
    }
}
