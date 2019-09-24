//
//  CalculatorMock.swift
//  CountOnMeTests
//
//  Created by Claire on 25/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation
@testable import CountOnMe

final class CalculatorMock: Calculator {
     
    var numberText: String?
    var operation: Operator?
    var deleteActionWasCalled = false
    var equalActionWasCalled = false
    
    override func tappedNumberButton(numberText: String) {
        self.numberText = numberText
    }
    
    override func tappedOperatorButton(operation: Operator) {
        self.operation = operation
    }
    
    override func tappedEqualButton() {
        self.equalActionWasCalled = true
    }
    
    override func tappedDeleteButton() {
        self.deleteActionWasCalled = true
    }
}
