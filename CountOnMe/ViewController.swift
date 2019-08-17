//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var state: CalculatorState = .writingCalculation
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
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
    
    //Usage replaced by state variable
//    var expressionHaveResult: Bool {
//        return textView.text.firstIndex(of: "=") != nil
//    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.text = "0"
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        switch state {
        case .writingCalculation:
            if numberText == "." {
                // textView.text = "0."
                
                //checking last
                if let last = elements.last {
                    //operator -> "0."
                    //number -> "."
                    //.
                    
                    switch last {
                    case ".":
                        break
                    case "+", "-", "x", "/":
                        textView.text.append("0.")
                    default :
                        textView.text.append(".")
                    }
                    
                } else {
                    //nothing...
                    textView.text = "0."
                }
                
            } else {
                textView.text.append(numberText)
            }
            
        case .displayingResult:
            if numberText == "." {
                textView.text = "0."
            } else {
                textView.text = numberText
            }
            
            state = .writingCalculation
        }
        
        
//        if expressionHaveResult {
//            textView.text = ""
//        }
//
//        textView.text.append(numberText)
//        state = .writingCalculation
//
        
        //state ?
        
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        switch state {
        case .writingCalculation:
            if canAddOperator {
                textView.text.append(" + ")
            } else {
                let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
            
        case .displayingResult(let value):
            //clean text
            textView.text = value
            textView.text.append(" + ")
            state = .writingCalculation
        }
        
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        switch state {
        case .writingCalculation:
            if canAddOperator {
                textView.text.append(" - ")
            } else {
                let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
            
        case .displayingResult(let value):
            //clean text
            textView.text = value
            textView.text.append(" - ")
            state = .writingCalculation
        }
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        switch state {
        case .writingCalculation:
            if canAddOperator {
                textView.text.append(" / ")
            } else {
                let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
            
        case .displayingResult(let value):
            //clean text
            textView.text = value
            textView.text.append(" / ")
            state = .writingCalculation
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        switch state {
        case .writingCalculation:
            if canAddOperator {
                textView.text.append(" x ")
            } else {
                let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
            
        case .displayingResult(let value):
            //clean text
            textView.text = value
            textView.text.append(" x ")
            state = .writingCalculation
        }
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        textView.text.removeAll()
        state = .writingCalculation
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard state == .writingCalculation else {
            textView.text.removeAll()
            state = .writingCalculation
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Float(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Float(operationsToReduce[2])!
            
            let result: Float
            
                switch operand {
                case "+": result = left + right
                case "-": result = left - right
                case "/": result = left / right
                case "x": result = left * right
                default:
                    return textView.text.removeAll()

                }
            
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textView.text.append(" = \(operationsToReduce.first!)")
        state = .displayingResult(value: operationsToReduce.first!)
    }
    
}

enum CalculatorState: Equatable {
    case writingCalculation
    case displayingResult(value: String)
}
