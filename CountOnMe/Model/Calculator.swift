//
//  Calculator.swift
//  CountOnMe
//
//  Created by Claire on 26/08/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

/// Use to define the state calculation
enum CalculatorState: Equatable {
    case writingCalculation
    case displayingResult(value: String)
}

class Calculator {
  
  let viewController: ViewController
  
  var state: CalculatorState = .writingCalculation
  
  var elements: [String] {
      return viewController.display.split(separator: " ").map { "\($0)" }
  }
  
  /// Error check computed variables
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
      return viewController.display.contains("/ 0")
  }
  
  init(viewController: ViewController) {
      self.viewController = viewController
      viewController.delegate = self
  }
  
  /// We apply operators priorities by calling the resolve function two times with different set of operators of equal priority, which are represented by a Tuple.
  private func resolve(elements: [String]) -> [String] {
      let array = resolve(operators: (.multiplication, .division), in: elements)
      return resolve(operators: (.addition, .substraction), in: array)
  }
  
  // Solves the given operators (parameters) in the equation represented by the elements array
  private func resolve(operators: (Operator, Operator), in elements: [String]) -> [String] {
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
                        if let operation = Operator(rawValue: operationsToReduce[index]){
                        
                          if let left = Double(operationsToReduce[index - 1]), let right = Double(operationsToReduce[index + 1]) {
                                
                                let result: Double = operation.operand(left: left, right: right)
                                                   
                                    operationsToReduce.remove(at: index - 1)
                                    operationsToReduce.remove(at: index - 1)
                                    operationsToReduce.insert("\(result)", at: index)
                                    operationsToReduce.remove(at: index - 1)
                                                   }
                            }
                       
                    }
            }
        return operationsToReduce
    }
}

extension Calculator: ViewControllerDelegate {
    
    func viewControllerTapperEqualButton(_ viewController: ViewController) {
        // Verification steps that check if we can proceed to do a calculation with the given expression, otherwise it's managing the error message corresponding.
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
        
        // If the user presses the Equal button while the calculator is displaying a result, we will set a 0 on screen, resetting the calculator
        guard state == .writingCalculation else {
            viewController.display = "0"
            state = .writingCalculation
            return
        }
        
        let operationsToReduce = resolve(elements: elements)
        
        //When the calculation is done, the expression strings array will be reduced to just one element: the result.
        if let value = operationsToReduce.first,
            let result = Double(value) {
            
            let resultString: String
            if  result.truncatingRemainder(dividingBy: 1.0) == 0 {
                //If the result is an integer, we will display no decimal values
                resultString = String(format: "%.f", result)
            } else {
                // If the result is a decimal value, we will display two numbers after the coma
                resultString = String(format: "%.2f", result)
            }
            
            viewController.display.append(" = \(resultString)")
            state = .displayingResult(value: resultString)
        }
    }
    
    
    func viewControllerTapperDeleteButton(_ viewController: ViewController) {
        viewController.display = "0"
        state = .writingCalculation
    }
    
    func viewControllerTapperOperatorButton(_ viewController: ViewController, operation: Operator) {
        switch state {
        case .writingCalculation:
            if doesContainsADivisionByZero {
                viewController.displayErrorMessage(type: .impossibleDivisionByZero)
                
            } else if canAddOperator {
                viewController.display.append(" " + operation.rawValue + " ")
                
            } else {
                viewController.displayErrorMessage(type: .lastCharacterIsAnOperator)
            }
            
        // In the case we are displaying a result and then we tap on an operator, we will take the result as the first value of a new equation
        case .displayingResult(let value):
            //clean text
            viewController.display = value
            viewController.display.append(" " + operation.rawValue + " ")
            state = .writingCalculation
        }
    }
    
    func viewControllerTapperNumberButton(_ viewController: ViewController, numberText: String) {
        // If the equation only contains a zero, we'll remove it in order to be replaced by the new number pressed by the user.
        if viewController.display == "0" {
            viewController.display.removeAll()
        }
        
        switch state {
        case .writingCalculation:
            if numberText == "." {
                if let last = elements.last  {
                    if last.contains(".") {
                        viewController.displayErrorMessage(type: .lastCharacterIsAComma)
                    } else {
                        if Operator(rawValue: last) != nil {
                            //If the last element in the equation is an operator, we will display a zero before the comma
                            viewController.display.append("0.")
                        } else {
                            viewController.display.append(".")
                        }
                    }
                } else {
                    //If there are no elements in the equation, we will display a zero followed by a comma
                    viewController.display = "0."
                }
            } else {
                // Checks if the last element in the equation is "0", if so, it is replaced by the number selected
                if let last = elements.last, last == "0", numberText == "\(numberText)"  {
                    viewController.display.removeLast()
                    viewController.display.append(numberText)
                    
                } else {
                    viewController.display.append(numberText)
                }
            }
            
        case .displayingResult:
            if numberText == "." {
                viewController.display = "0."
            } else {
                viewController.display = numberText
            }
            state = .writingCalculation
        }
    }
}
