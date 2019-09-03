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
    
    func viewControllerTapperOperatorButton(_ viewController: ViewController, operation: Operator)
    
    func viewControllerTapperEqualButton(_ viewController: ViewController)
    
    func viewControllerTapperDeleteButton(_ viewController: ViewController)
}

enum MessageErrorType {
    case lastCharacterIsAComma
    case impossibleDivisionByZero
    case lastCharacterIsAnOperator
    case expressionIsNotCorrect
    case expressionDoesNotHaveEnoughElement
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
        case .expressionIsNotCorrect:
            return "Entrez une expression correcte !"
        case .expressionDoesNotHaveEnoughElement:
            return "Démarrez un nouveau calcul !"
        }
    }
    
    var title: String {
        switch self {
        case .lastCharacterIsAComma,
             .lastCharacterIsAnOperator,
             .expressionIsNotCorrect,
             .expressionDoesNotHaveEnoughElement:
            return "Erreur"
        case .impossibleDivisionByZero:
            return "Zéro!"
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
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
        delegate?.viewControllerTapperOperatorButton(self, operation: .addition)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOperatorButton(self, operation: .substraction)
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOperatorButton(self, operation: .division)
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        delegate?.viewControllerTapperOperatorButton(self, operation: .multiplication)
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        delegate?.viewControllerTapperDeleteButton(self)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
       delegate?.viewControllerTapperEqualButton(self)
    }
}
