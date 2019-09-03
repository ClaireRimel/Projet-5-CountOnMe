//
//  ViewControllerMock.swift
//  CountOnMeTests
//
//  Created by Claire on 03/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation
@testable import CountOnMe

final class ViewControllerMock: ViewController {
    
    var type: MessageErrorType?
    
    override func displayErrorMessage(type: MessageErrorType) {
        self.type = type
    }
}
