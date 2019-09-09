//
//  MessageErrorTypeTests.swift
//  CountOnMeTests
//
//  Created by Claire on 10/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class MessageErrorTypeTests: XCTestCase {
    
    //MARK: Message
    func testLastCharacterIsACommaCaseMessage() {
        XCTAssertEqual(MessageErrorType.lastCharacterIsAComma.message, "Une virgule est déja mise")
    }
    
    func testImpossibleDivisionByZeroCaseMessage() {
        XCTAssertEqual(MessageErrorType.impossibleDivisionByZero.message, "Division par 0 impossible")
    }
    
    func testLastCharacterIsAnOperatorCaseMessage() {
        XCTAssertEqual(MessageErrorType.lastCharacterIsAnOperator.message, "Un operateur est déja mis !")
    }
    
    func testExpressionIsNotCorrectCaseMessage() {
        XCTAssertEqual(MessageErrorType.expressionIsNotCorrect.message, "Entrez une expression correcte !")
    }
    
    func testExpressionDoesNotHaveEnoughElementCaseMessage() {
        XCTAssertEqual(MessageErrorType.expressionDoesNotHaveEnoughElement.message, "Démarrez un nouveau calcul !")
    }
    
    //MARK: Title
    func testLastCharacterIsACommaCaseTitle() {
        XCTAssertEqual(MessageErrorType.lastCharacterIsAComma.title, "Erreur")
    }
    
    func testImpossibleDivisionByZeroCaseTitle() {
        XCTAssertEqual(MessageErrorType.impossibleDivisionByZero.title, "Zéro!")
    }
    
    func testLastCharacterIsAnOperatorCaseTitle() {
        XCTAssertEqual(MessageErrorType.lastCharacterIsAnOperator.title, "Erreur")
    }
    
    func testExpressionIsNotCorrectCaseTitle() {
        XCTAssertEqual(MessageErrorType.expressionIsNotCorrect.title, "Erreur")
    }
    
    func testExpressionDoesNotHaveEnoughElementCaseTitle() {
        XCTAssertEqual(MessageErrorType.expressionDoesNotHaveEnoughElement.title, "Erreur")
    }
}
