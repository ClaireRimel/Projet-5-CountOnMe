//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

// Notifies the model that a specific action was tapped by the user on the view
protocol ViewControllerDelegate: class {
    
    func viewControllerTapperNumberButton(_ viewController: ViewController, numberText: String)
    
    func viewControllerTapperOperatorButton(_ viewController: ViewController, operation: Operator)
    
    func viewControllerTapperEqualButton(_ viewController: ViewController)
    
    func viewControllerTapperDeleteButton(_ viewController: ViewController)
}

protocol ViewControllerInterface {

    var display: String { get set }

    func displayErrorMessage(type: MessageErrorType)
}

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    weak var delegate: ViewControllerDelegate?
    
    var display: String {
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
        //Initially the calculator displays a 0 on screen
        textView.text = "0"
    }
    
    // Configures the UIAlertController to be displayed using the received MessageErrorType's title and message properties
    func displayErrorMessage(type: MessageErrorType){
        let alertVC = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        delegate?.viewControllerTapperNumberButton(self, numberText: numberText)
    }
    
    // Gives the corresponding kind of operator case depending on the action
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
