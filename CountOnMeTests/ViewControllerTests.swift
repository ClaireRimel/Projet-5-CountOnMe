//
//  ViewControllerTests.swift
//  CountOnMeTests
//
//  Created by Claire on 10/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    var delegateMock: ViewControllerDelegateMock!
    
    override func setUp() {
        sut = ViewController()
        sut.textView = UITextView()
        sut.numberButtons = [UIButton()]
        
        delegateMock = ViewControllerDelegateMock()

        sut.delegate = delegateMock
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Mark: Numbers
    
    func testTappedNumberButtonDelegate() {
        //Given
        let button = UIButton()
        button.setTitle("1", for: .normal)
        
        //When
        sut.tappedNumberButton(button)
        
        //Then
        XCTAssertEqual(delegateMock.numberText, "1")
    }
    
    // MARK: operators
    func testTappedAdditionButtonDelegate() {
        //Given
        sut.textView.text = "123"
        
        //When
        sut.tappedAdditionButton(UIButton())
        
        //Then
        XCTAssertEqual(delegateMock.operation, .addition)
    }
    
    func testTappedSubstractionButtonDelegate() {
        //Given
        sut.textView.text = "123"
        
        //When
        sut.tappedSubstractionButton(UIButton())
        
        //Then
        XCTAssertEqual(delegateMock.operation, .substraction)
    }
    
    
    func testTappedMultiplicationButtonDelegate() {
        //Given
        sut.textView.text = "123"
        
        //When
        sut.tappedMultiplicationButton(UIButton())
        
        //Then
        XCTAssertEqual(delegateMock.operation, .multiplication)
    }
    
    func testTappedDivisionButtonDelegate() {
        //Given
        sut.textView.text = "123"
        
        //When
        sut.tappedDivisionButton(UIButton())
        
        //Then
        
        XCTAssertEqual(delegateMock.operation, .division)
    }
    
    // MARK: Equal
    func testTappedEqualButtonDelegate() {
        //Given
        delegateMock.equalActionWasCalled = false
        
        //When
        sut.tappedEqualButton(UIButton())
        
        //Then
        XCTAssertEqual(delegateMock.equalActionWasCalled, true)
    }
    
    // MARK: Delete
    func testTappedDeleteButtonDelegate() {
        //Given
        delegateMock.deleteActionWasCalled = false
        
        //When
        sut.tappedDeleteButton(UIButton())
        
        //Then
        XCTAssertEqual(delegateMock.deleteActionWasCalled, true)
    }
    
    func testViewDidLoad() {
        //Given
        XCTAssertEqual(sut.textView.text, "")

        //When
        sut.viewDidLoad()
        
        //Then
        XCTAssertEqual(sut.textView.text, "0")
    }
}
