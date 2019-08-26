//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate: class {
    
    func viewControllerTapperNumberButton(_ viewController: ViewController, numberText: String)
    
    func viewControllerTapperOpperatorButton(_ viewController: ViewController, operation: Operator)
//    func viewControllerTapperEqualButton(_ viewController: ViewController)
    func viewControllerTapperDeleteButton(_ viewController: ViewController)
}

enum MessageErrorType {
    case lastCharacterIsAComma
    case impossibleDivisionByZero
    case lastCharacterIsAnOperator
}

extension MessageErrorType {
    
    var message: String {
        switch self {
        case .lastCharacterIsAComma:
            return  "Une virgule est déja mise"
        case .impossibleDivisionByZero:
            return "Division par 0 impossible"
        case .lastCharacterIsAnOperator:
            return "Un operateur est déja mis !"
        }
    }
    
    var title: String {
        switch self {
        case .lastCharacterIsAComma, .lastCharacterIsAnOperator:
            return "Erreur"
        case .impossibleDivisionByZero:
            return "Zéro!"
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    weak var delegate: ViewControllerDelegate?
    
    func displayErrorMessage(type: MessageErrorType){
        let alertVC = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // Work in progress 
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
        
        delegate?.viewControllerTapperNumberButton(self, numberText: numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOpperatorButton(self, operation: .addition)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOpperatorButton(self, operation: .substraction)
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOpperatorButton(self, operation: .division)
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOpperatorButton(self, operation: .multiplication)
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        delegate?.viewControllerTapperDeleteButton(self)
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
            
            textView.text.append(" = \(resultString)")
            state = .displayingResult(value: resultString)
        }
    }
}
