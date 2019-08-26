//
//  Calculator.swift
//  CountOnMe
//
//  Created by Claire on 26/08/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation


class Calculator {
    
    let viewController: ViewController
    
    var state: CalculatorState = .writingCalculation
    
    var elements: [String] {
        return viewController.textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "x"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "x"
    }

    init(viewController: ViewController) {
        self.viewController = viewController
    }
}

extension Calculator: ViewControllerDelegate {
    func viewControllerTapperEqualButton(_ viewController: ViewController) {
        guard expressionIsCorrect else {
            viewController.displayErrorMessage(type: .expressionIsNotCorrect)
            return
        }
        
        guard expressionHaveEnoughElement else {
            viewController.displayErrorMessage(type: .expressionDoesNotHaveEnoughElement)
            return
        }
        
        guard state == .writingCalculation else {
            viewController.textView.text.removeAll()
            state = .writingCalculation
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.contains(Operator.multiplication.rawValue)
            || operationsToReduce.contains(Operator.division.rawValue) {
                
                let index = operationsToReduce.firstIndex { (element) -> Bool in
                    if let operation = Operator(rawValue: element),
                        operation == .multiplication || operation == .division {
                        return true
                    } else {
                        return false
                    }
                }
                
                if let index = index {
                    let operation = Operator(rawValue: operationsToReduce[index])!
                    
                    let left = Double(operationsToReduce[index - 1])!
                    let right = Double(operationsToReduce[index + 1])!
                    let result: Double = operation.operand(left: left, right: right)
                    
                    operationsToReduce.remove(at: index - 1)
                    operationsToReduce.remove(at: index - 1)
                    operationsToReduce.insert("\(result)", at: index)
                    operationsToReduce.remove(at: index - 1)
                }
        }
        
        // Iterate over operations while an operand still here
        while operationsToReduce.contains(Operator.addition.rawValue)
            || operationsToReduce.contains(Operator.substraction.rawValue) {
                
                let index = operationsToReduce.firstIndex { (element) -> Bool in
                    if let operation = Operator(rawValue: element),
                        operation == .addition || operation == .substraction {
                        return true
                    } else {
                        return false
                    }
                }
                
                if let index = index {
                    let operation = Operator(rawValue: operationsToReduce[index])!
                    
                    let left = Double(operationsToReduce[index - 1])!
                    let right = Double(operationsToReduce[index + 1])!
                    let result: Double = operation.operand(left: left, right: right)
                    
                    operationsToReduce.remove(at: index - 1)
                    operationsToReduce.remove(at: index - 1)
                    operationsToReduce.insert("\(result)", at: index)
                    operationsToReduce.remove(at: index - 1)
                }
        }
        
        if let value = operationsToReduce.first,
            let result = Double(value) {
            
            let resultString: String
            if  result.truncatingRemainder(dividingBy: 1.0) == 0 {
                resultString = String(format: "%.f", result)
            } else {
                resultString = String(format: "%.2f", result)
            }
            
            viewController.textView.text.append(" = \(resultString)")
            state = .displayingResult(value: resultString)
        }
    }
    
    
    func viewControllerTapperDeleteButton(_ viewController: ViewController) {
        viewController.textView.text.removeAll()
        state = .writingCalculation
    }
    
    func viewControllerTapperOpperatorButton(_ viewController: ViewController, operation: Operator) {
        switch state {
        case .writingCalculation:
            if canAddOperator {
                viewController.textView.text.append(" " + operation.rawValue + " ")

            } else {
                viewController.displayErrorMessage(type: .lastCharacterIsAnOperator)
            }
            
        case .displayingResult(let value):
            //clean text
            viewController.textView.text = value
            viewController.textView.text.append(" " + operation.rawValue + " ")
            state = .writingCalculation
        }
        
    }
    
    func viewControllerTapperNumberButton(_ viewController: ViewController, numberText: String) {
        if viewController.textView.text == "0" {
            viewController.textView.text.removeAll()
        }
        
        switch state {
        case .writingCalculation:
            
            if numberText == "." {
                //checking last
                if let last = elements.last  {
                    if last.contains(".") {
                        viewController.displayErrorMessage(type: .lastCharacterIsAComma)
                    } else {
                        switch last {
                        case "+", "-", "x", "/":
                            viewController.textView.text.append("0.")
                        default :
                            viewController.textView.text.append(".")
                        }
                    }
                } else {
                    //nothing...
                    viewController.textView.text = "0."
                }
            } else {
                if let last = elements.last, last == "0", numberText == "\(numberText)"  {
                    viewController.textView.text.removeLast()
                    viewController.textView.text.append(numberText)
                    
                } else {
                    if let last = elements.last, last == "/", numberText == "0" {
                        viewController.displayErrorMessage(type: .impossibleDivisionByZero)
                    } else {
                        viewController.textView.text.append(numberText)
                    }
                }
            }
            
        case .displayingResult:
            if numberText == "." {
                viewController.textView.text = "0."
            } else {
               viewController.textView.text = numberText
            }
            
            state = .writingCalculation
        }
    }
    
    
}


enum CalculatorState: Equatable {
    case writingCalculation
    case displayingResult(value: String)
}

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


