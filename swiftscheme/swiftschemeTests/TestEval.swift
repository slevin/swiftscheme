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

    func testLet() {
        let r = runIt("(let ((a 1) (b 2)) (+ a b))")
        XCTAssertEqual(E.IntEl(3), r)
    }
    
    func testNestedLets() {
        // lets create nested environemnts
        let r = runIt("(let ((a 1)) (+ (let ((a 2) (b 3)) (+ a b)) a))")
        XCTAssertEqual(E.IntEl(6), r)
    }
    
    func testLambdaReturnsFunEl() {
        let r = runIt("(lambda () 1)")
        XCTAssertEqual(E.FunEl(FunctionData(body: E.IntEl(1), args:E.ListEl([]))), r)
    }
    
    func testEvalFunRunsIt() {
        let r = runIt("((lambda () 1))")
        XCTAssertEqual(E.IntEl(1), r)
    }
    
    func testLambdaWrongArgCount() {
        let r = runIt("(lambda ())")
        XCTAssertTrue(r.isError)
    }

    func testLambdaRequiresListAsFirstArg() {
        let r = runIt("(lambda 1 2)")
        XCTAssertTrue(r.isError)
    }
    
    func testLambdaSavesArgs() {
        let r = runIt("(lambda (a) 1)")
        switch r {
        case .FunEl(let f):
            XCTAssertEqual(E.ListEl([E.SymbolEl("a")]), f.args)
        default:
            XCTFail("Must be FunEl")
        }
    }
    
    func testFunArgsAreAssigned() {
        let r = runIt("((lambda (a b) (+ a b)) 4 5)")
        XCTAssertEqual(E.IntEl(9), r)
    }
    
    func testNotMatchingArgumentsIsError() {
        let r = runIt("((lambda (a b) (+ a b)) 4)")
        XCTAssertTrue(r.isError)
    }

    func testCompareNotTwoError() {
        let r = runIt("(< 1)")
        XCTAssertTrue(r.isError)
    }

    func testDefineRequriesTwoArguments() {
        let r = runIt("(define x)")
        XCTAssertTrue(r.isError)
    }
    
    func testIfRequiresThreeArguments() {
        let r = runIt("(if #t 1)")
        XCTAssertTrue(r.isError)
    }
    
    func testIfRequiresBoolFirstArgument() {
        let r = runIt("(if 1 2 3)")
        XCTAssertTrue(r.isError)
    }
    
    func testIfRequiresEvaledBoolFirstArgument() {
        let r = runIt("(if (> 1 0) 1 2)")
        XCTAssertEqual(E.IntEl(1), r)
    }
    
    func testEvalUndefinedFunctionIsError () {
        let r = runIt("(undefined a b)")
        XCTAssertTrue(r.isError)
    }
    
    func testRecurEval() {
        let r = runIt("(recur 1 (+ 2 3))")
        switch r {
        case .RecurEl(let f):
            // recur data contains el 1 and el 5
            XCTAssertEqual(E.RecurEl(RecurData(args:E.ListEl([E.IntEl(1), E.IntEl(5)]))), r)
        default:
            XCTFail()
        }
    }
    
    func testRecur() {
        let r = runIt("((lambda (a acc) (if (= a 0) acc (recur (- a 1) (+ acc a)))) 3 0)")
        XCTAssertEqual(E.IntEl(6), r)
    }
    
    func testRecurWithWrongElementCountIsError() {
        let r = runIt("((lambda (a acc) (if (= a 0) acc (recur (- a 1)))) 3 0)")
        XCTAssertTrue(r.isError)
        
    }

    func testLetWithOneParamIsError() {
        let r = runIt("(let ((a 1)))")
        XCTAssertTrue(r.isError)
    }
    
    func testLetWithNonListAsFirstParameterIsError() {
        let r = runIt("(let 1 (+ 2 3))")
        XCTAssertTrue(r.isError)
    }
    
    func testLetFirstParamIsListOfLists() {
        let r = runIt("(let (1) (+ 2 3))")
        XCTAssertTrue(r.isError)
    }
    
    func testLetFirstParamIsListOf2() {
        let r = runIt("(let ((1)) (+ 2 3))")
        XCTAssertTrue(r.isError)
    }
    
    func testMultiply() {
        let r = runIt("(* 4 5)")
        XCTAssertEqual(E.IntEl(20), r)
    }
    
    func testMultiplyDouble() {
        let r = runIt("(* 4.0 5.0)")
        XCTAssertEqual(E.DoubleEl(20), r)
    }
    
    func testDivideInts() {
        let r = runIt("(/ 20 4)")
        XCTAssertEqual(E.DoubleEl(5), r)
    }

    func testDivideDouble() {
        let r = runIt("(/ 20.0 5.0)")
        XCTAssertEqual(E.DoubleEl(4), r)
    }
    
}
