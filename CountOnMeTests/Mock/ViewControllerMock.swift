//
//  ViewControllerMock.swift
//  CountOnMeTests
//
//  Created by Claire on 03/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation
@testable import CountOnMe

// Acts as a ViewController mock to be used by the Calculator class for testing purposes 
final class ViewControllerMock: ViewController {
    
    var error: MessageErrorType?
    
    override func calculator(_ calculator: Calculator, didFailWithError error: MessageErrorType) {
        self.error = error
    }
}
