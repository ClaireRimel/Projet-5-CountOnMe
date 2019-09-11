//
//  Calculator.swift
//  CountOnMe
//
//  Created by Claire on 26/08/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum CalculatorState: Equatable {
    case writingCalculation
    case displayingResult(value: String)
}

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
    
    var doesContainsADivisionByZero: Bool {
        return viewController.textView.text.contains("/ 0")
    }
    
    init(viewController: ViewController) {
        self.viewController = viewController
        viewController.delegate = self
    }
    
    func resolve(elements: [String]) -> [String] {
        let array = resolve(operators: (.multiplication, .division), in: elements)
        return resolve(operators: (.addition, .substraction), in: array)
    }
    
    func resolve(operators: (Operator, Operator), in elements: [String]) -> [String] {
       // Model var operationsToReduce = elements
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.contains(operators.0.rawValue)
            || operationsToReduce.contains(operators.1.rawValue) {
        
                let index = operationsToReduce.firstIndex { (element) -> Bool in
                    if let operation = Operator(rawValue: element),
                        operation == operators.0 || operation == operators.1 {
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
        return operationsToReduce
    }
}

extension Calculator: ViewControllerDelegate {
    
    func viewControllerTapperEqualButton(_ viewController: ViewController) {
        guard expressionHaveEnoughElement else {
            viewController.displayErrorMessage(type: .expressionDoesNotHaveEnoughElement)
            return
        }
        
        guard expressionIsCorrect else {
            viewController.displayErrorMessage(type: .expressionIsNotCorrect)
            return
        }
        
        guard !doesContainsADivisionByZero else {
            viewController.displayErrorMessage(type: .impossibleDivisionByZero)
            return
        }
        
        guard state == .writingCalculation else {
            viewController.textView.text = "0"
            state = .writingCalculation
            return
        }
        
        // Create local copy of operations
        let operationsToReduce = resolve(elements: elements)
    
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
        viewController.textView.text = "0"
        state = .writingCalculation
    }
    
    func viewControllerTapperOperatorButton(_ viewController: ViewController, operation: Operator) {
        switch state {
        case .writingCalculation:
            
            if doesContainsADivisionByZero {
                viewController.displayErrorMessage(type: .impossibleDivisionByZero)
                
            } else if canAddOperator {
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
                        if Operator(rawValue: last) != nil {
                            viewController.textView.text.append("0.")
                        } else {
                            viewController.textView.text.append(".")
                        }
                    }
                } else {
                    viewController.textView.text = "0."
                }
            } else {
                if let last = elements.last, last == "0", numberText == "\(numberText)"  {
                    viewController.textView.text.removeLast()
                    viewController.textView.text.append(numberText)
                    
                    } else {
                        viewController.textView.text.append(numberText)
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







