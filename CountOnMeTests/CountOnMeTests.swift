//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Claire on 29/08/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {

    //System Under Test
    var sut: Calculator!
    var viewController: ViewControllerMock!
    
    override func setUp() {
        
        viewController = ViewControllerMock()
        viewController.textView = UITextView()
        viewController.numberButtons = [UIButton()]

        sut = Calculator(viewController: viewController)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: Delete action
    
    func testSetsStateWritingCalculationOnDeleteAction() {
        //Given
        XCTAssertEqual(sut.state, .writingCalculation)
        
        //When
        sut.viewControllerTapperDeleteButton(viewController)
        
        //Then
        XCTAssertEqual(sut.state, .writingCalculation)
    }
    
    func testSetsEmptyStringToTextViewOnDeleteAction() {
        //Given
        viewController.textView.text = "hello"
        
        //When
        sut.viewControllerTapperDeleteButton(viewController)
        
        //Then
        XCTAssertEqual(viewController.textView.text, "")
    }
    
    //MARK: Operators
    
    func testCanAddOperator() {
        //Given
        sut.state = .writingCalculation
        viewController.textView.text = "1"

        //When
        sut.viewControllerTapperOperatorButton(viewController, operation: .addition)

        //Then
        XCTAssertEqual(viewController.textView.text, "1 + ")
    }
    
    func testCannotAddOperator() {
        //Given
        sut.state = .writingCalculation
        viewController.textView.text = "-"

        //When
        sut.viewControllerTapperOperatorButton(viewController, operation: .addition)

        //Then
        XCTAssertEqual(viewController.type, .lastCharacterIsAnOperator)
    }
    
    func testDisplaysOperatorAfterCalculation() {
        //Given
        sut.state = .displayingResult(value: "23")
        
        //When
        sut.viewControllerTapperOperatorButton(viewController, operation: .addition)
        
        //Then
        XCTAssertEqual(viewController.textView.text, "23 + ")
        XCTAssertEqual(sut.state, .writingCalculation)
    }
}


