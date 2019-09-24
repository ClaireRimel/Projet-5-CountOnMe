//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Claire on 29/08/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorDelegateMock: CalculatorDelegate {
    var output: String = ""
    var error: MessageErrorType?

    func calculator(_ calculator: Calculator, didFailWithError error: MessageErrorType) {
        self.error = error
    }
}


class CountOnMeTests: XCTestCase {

    //System Under Test
    var sut: Calculator!
    var delegateMock: CalculatorDelegateMock!
    
    override func setUp() {
        super.setUp()
        
        delegateMock = CalculatorDelegateMock()
        sut = Calculator()
        sut.delegate = delegateMock
    }
    
    override func tearDown() {}
    
    //MARK: Delete action
    
    func testSetsStateWritingCalculationOnDeleteAction() {
        //Given
        XCTAssertEqual(sut.state, .writingCalculation)
        
        //When
        sut.tappedDeleteButton()
        
        //Then
        XCTAssertEqual(sut.state, .writingCalculation)
    }
    
    func testSetsEmptyStringToTextViewOnDeleteAction() {
        //Given
        delegateMock.output = "123"
        
        //When
        sut.tappedDeleteButton()
        
        //Then
        XCTAssertEqual(delegateMock.output, "0")
    }
    
    //MARK: Operators
    
    func testCanAddOperator() {
        for operation in Operator.allCases {
            //Given
            sut.state = .writingCalculation
            delegateMock.output = "1"
            
            //When
            sut.tappedOperatorButton(operation: operation)

            //Then
            XCTAssertEqual(delegateMock.output, "1 \(operation.rawValue) ")
        }
    }
    
    func testCannotAddOperator() {
        for operation in Operator.allCases {
            //Given
            sut.state = .writingCalculation
            delegateMock.output = "-"
            
            //When
            sut.tappedOperatorButton(operation: operation)
            
            //Then
            XCTAssertEqual(delegateMock.error, .lastCharacterIsAnOperator)
        }
    }
    
    func testImpossibleDivisionByZeroDisplaysErrorAddingAnOperator() {
        for operation in Operator.allCases {
            //Given
            sut.state = .writingCalculation
            delegateMock.output = "23 / 0"
            
            //When
            sut.tappedOperatorButton(operation: operation)
            
            //Then
            XCTAssertEqual(delegateMock.error, .impossibleDivisionByZero)
        }
    }
    
    func testDisplaysOperatorAfterCalculation() {
        for operation in Operator.allCases {
            //Given
            sut.state = .displayingResult(value: "23")
            
            //When
            sut.tappedOperatorButton(operation: operation)
            
            //Then
            XCTAssertEqual(delegateMock.output, "23 \(operation.rawValue) ")
            XCTAssertEqual(sut.state, .writingCalculation)
        }
    }
    
    // MARK: Numbers
    
    func testRemovesZeroDisplayedWhenPressingANumber() {
        //Given
        sut.state = .writingCalculation
        delegateMock.output = "0"
        
        //When
        sut.tappedNumberButton(numberText: "1")
        
        //Then
        XCTAssertEqual(delegateMock.output, "1")
    }
    
    func testAddingCommaAfterACommaDisplaysError() {
        //Given
        sut.state = .writingCalculation
        delegateMock.output = "."
        
        //When
        sut.tappedNumberButton(numberText: ".")
       
        //Then
        XCTAssertEqual(delegateMock.error, .lastCharacterIsAComma)
    }
    
    func testAddingCommaAfterAnOperatorAppendsAZeroPlusAComma() {
        for operation in Operator.allCases {
            //Given
            sut.state = .writingCalculation
            delegateMock.output = "23 \(operation.rawValue) "
            
            //When
            sut.tappedNumberButton(numberText: ".")
            
            //Then
            XCTAssertEqual(delegateMock.output, "23 \(operation.rawValue) 0.")
        }
    }
    
    func testAddingCommaAfterANumber() {
        //Given
        sut.state = .writingCalculation
        delegateMock.output = "23"
        
        //When
        sut.tappedNumberButton(numberText: ".")
        
        //Then
        XCTAssertEqual(delegateMock.output, "23.")
    }
    
    func testAddingZeroPlusCommaIfEmptyTextView() {
        //Given
        sut.state = .writingCalculation
        delegateMock.output = ""
        
        //When
        sut.tappedNumberButton(numberText: ".")
        
        //Then
        XCTAssertEqual(delegateMock.output, "0.")
    }
    
    func testReplaceTheLastElementIfZeroByTheTappedNumber() {
        //Given
        sut.state = .writingCalculation
        delegateMock.output = "23 + 0"
        
        //When
        sut.tappedNumberButton(numberText: "3")
        
        //Then
        XCTAssertEqual(delegateMock.output, "23 + 3")
    }
    
    func testImpossibleDivisionByZeroDisplaysErrorTappedEgualButton() {
        //Given
        delegateMock.output = "23 / 0"
        
        //When
        sut.tappedEqualButton()
        
        //Then
        XCTAssertEqual(delegateMock.error, .impossibleDivisionByZero)
    }
    
    func testPossibleDivisionByOtherNumbers() {
        //Given
        sut.state = .writingCalculation
        delegateMock.output = "23 / "
        
        //When
        sut.tappedNumberButton(numberText: "4")
        
        //Then
        XCTAssertEqual(delegateMock.output, "23 / 4")
    }
    
    func testPossibilityOfAddingAZeroAfterOperatorsAddSubstractAndMutliply() {
        for operation in [Operator.addition, Operator.substraction, Operator.multiplication ] {
            //Given
            sut.state = .writingCalculation
            delegateMock.output = "23 \(operation.rawValue) "
            
            //When
            sut.tappedNumberButton(numberText: "0")
            
            //Then
            XCTAssertEqual(delegateMock.output, "23 \(operation.rawValue) 0")
        }
    }
    
    func testAddingCommaAfterDisplayingResult() {
        //Given
        sut.state = .displayingResult(value: "23")
        
        //When
        sut.tappedNumberButton(numberText: ".")
        
        //Then
        XCTAssertEqual(delegateMock.output, "0.")
        XCTAssertEqual(sut.state, .writingCalculation)
    }
    
    func testAddingNumberAfterDisplayingResult() {
        //Given
        sut.state = .displayingResult(value: "23")
        
        //When
        sut.tappedNumberButton(numberText: "44")
        
        //Then
        XCTAssertEqual(delegateMock.output, "44")
        XCTAssertEqual(sut.state, .writingCalculation)
    }
    
    // MARK: Result
    
    func testDisplayErrorMessageIfExpressionDontHaveEnoughElements() {
        //Given
        delegateMock.output = "23 +"
        
        //When
        sut.tappedEqualButton()
        
        //Then
        XCTAssertEqual(delegateMock.error, .expressionDoesNotHaveEnoughElement)
    }
    
    func testDisplayErrorMessageIfExpressionIsFalse() {
        //Given
        delegateMock.output = "2 + 3 +"
        
        //When
        sut.tappedEqualButton()
        
        //Then
        XCTAssertEqual(delegateMock.error, .expressionIsNotCorrect)
    }
    
    func testVerifyStateIsWritingCalculation() {
        //Given
        delegateMock.output = "2 + 4"
        sut.state = .displayingResult(value: "23")
        
        //When
        sut.tappedEqualButton()
        
        //Then
        XCTAssertEqual(delegateMock.output, "0")
        XCTAssertEqual(sut.state, .writingCalculation)
    }
    
    func testAdditionOperation() {
        //Given
        delegateMock.output = "2 + 3"

        //When
        sut.tappedEqualButton()
        //Then

        XCTAssertEqual(delegateMock.output, "2 + 3 = 5")
    }
    
    func testSbustractionOperation() {
        //Given
       delegateMock.output = "2 - 3"
        
        //When
        sut.tappedEqualButton()
        //Then
        
        XCTAssertEqual(delegateMock.output, "2 - 3 = -1")
    }
    
    func testMultiplicationOperation() {
        //Given
        delegateMock.output = "2 x 3"
        
        //When
        sut.tappedEqualButton()
        //Then
        
        XCTAssertEqual(delegateMock.output, "2 x 3 = 6")
    }
    
    func testDivisionOperation() {
        //Given
        delegateMock.output = "2 / 3"
        
        //When
        sut.tappedEqualButton()
        //Then
        
        XCTAssertEqual(delegateMock.output, "2 / 3 = 0.67")
    }
    
    func testPrioritiesOperation() {
        //Given
        delegateMock.output = "2 + 3 / 3 x 4 - 5 x 2 / 3"
        
        //When
        sut.tappedEqualButton()
        //Then
        
        XCTAssertEqual(delegateMock.output, "2 + 3 / 3 x 4 - 5 x 2 / 3 = 2.67")
    }
}


