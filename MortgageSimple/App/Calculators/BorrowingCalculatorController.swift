//
//  BorrowingCalculatorControllerViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 22/05/2023.
//

import UIKit

class BorrowingCalculatorController: UIViewController {

    @IBOutlet weak var loanLowerBoundLabel: UILabel!
    @IBOutlet weak var loanUpperBoundLabel: UILabel!
    
    @IBOutlet weak var incomeLabel: UILabel!
    
    var income: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func incomeSliderChanged(_ sender: UISlider) {
        income = sender.value
        calculateAndDisplayBorrowing()
    }
    
    private func calculateAndDisplayBorrowing() {
        loanLowerBoundLabel.text = "£\(Utility.getFormattedNumber(income * 3, decimalPoints: 0))"
        loanUpperBoundLabel.text = "£\(Utility.getFormattedNumber(income * 5, decimalPoints: 0))"
        incomeLabel.text = "£\(Utility.getFormattedNumber(income, decimalPoints: 0))"
    }
}
