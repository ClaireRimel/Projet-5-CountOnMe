//
//  OperatorTests.swift
//  CountOnMeTests
//
//  Created by Claire on 10/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class OperatorTests: XCTestCase {

    // MARK: Raw Value
    func testOperatorMultiplicationtionRawValue() {
        XCTAssertEqual(Operator.multiplication.rawValue, "x")
    }
    
    func testOperatorDivitionRawValue() {
        XCTAssertEqual(Operator.division.rawValue, "/")
    }
    
    func testOperatorAdditionRawValue() {
        XCTAssertEqual(Operator.addition.rawValue, "+")
    }
    
    func testOperatorSubstrationRawValue() {
        XCTAssertEqual(Operator.substraction.rawValue, "-")
    }
    
    //MARK: Operand
    func testOperatorMultiplicationtionOperand() {
        
        let result = Operator.multiplication.operand(left: 2, right: 3)
        XCTAssertEqual(result, 6)
    }
    
    func testOperatorDivitionOperand() {
        let result = Operator.division.operand(left: 3, right: 3)
        XCTAssertEqual(result, 1)
    }
    
    func testOperatorAdditionOperand() {
        let result = Operator.addition.operand(left: 2, right: 3)
        XCTAssertEqual(result, 5)
    }
    
    func testOperatorSubstrationOperand() {
        let result = Operator.substraction.operand(left: 2, right: 3)
        XCTAssertEqual(result, -1)
    }
}
