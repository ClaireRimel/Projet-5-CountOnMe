//
//  Operator.swift
//  CountOnMe
//
//  Created by Claire on 09/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

/// List of supported operations by the Calculator. The rawValues represent each operator symbol.
enum Operator: String, CaseIterable, RawRepresentable {
    case multiplication = "x"
    case division = "/"
    case addition = "+"
    case substraction = "-"
}

extension Operator {
    
    func operand(left: Double, right: Double) -> Double {
        switch self {
        case .multiplication:
            return left * right
        case .division:
            return left / right
        case .addition:
            return left + right
        case .substraction:
            return left - right
        }
    }
}
