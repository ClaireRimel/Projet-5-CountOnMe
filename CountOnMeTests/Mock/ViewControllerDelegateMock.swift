//
//  ViewControllerDelegateMock.swift
//  CountOnMeTests
//
//  Created by Claire on 10/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation
@testable import CountOnMe

final class ViewControllerDelegateMock: ViewControllerDelegate {
    var deleteActionWasCalled = false
    var equalActionWasCalled = false
    var operation: Operator?
    var numberText: String?
    
    
    func viewControllerTapperNumberButton(_ viewController: ViewController, numberText: String) {
        self.numberText = numberText
    }
    
    func viewControllerTapperOperatorButton(_ viewController: ViewController, operation: Operator) {
        self.operation = operation
    }
    
    func viewControllerTapperEqualButton(_ viewController: ViewController) {
        equalActionWasCalled = true
    }
    
    func viewControllerTapperDeleteButton(_ viewController: ViewController) {
        deleteActionWasCalled = true
    }
}
