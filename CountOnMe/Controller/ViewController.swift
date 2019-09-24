//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
        
    let calculator = Calculator()
    
    var output: String {
           get {
               return textView.text
           }
           set {
               textView.text = newValue
           }
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculator.delegate = self
        //Initially the calculator displays a 0 on screen
        textView.text = "0"
    }
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        calculator.tappedNumberButton(numberText: numberText)
    }
    
    // Gives the corresponding kind of operator case depending on the action
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calculator.tappedOperatorButton(operation: .addition)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calculator.tappedOperatorButton(operation: .substraction)
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        calculator.tappedOperatorButton(operation: .division)
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        calculator.tappedOperatorButton(operation: .multiplication)
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        calculator.tappedDeleteButton()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.tappedEqualButton()
    }
}

extension ViewController: CalculatorDelegate {
    
    // Configures the UIAlertController to be displayed using the received MessageErrorType's title and message properties
    func calculator(_ calculator: Calculator, didFailWithError error: MessageErrorType) {
        let alertVC = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
