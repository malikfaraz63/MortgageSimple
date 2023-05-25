//
//  MortageCalculatorController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 21/05/2023.
//

import UIKit

class MortgageCalculatorController: UIViewController {

    @IBOutlet weak var monthlyRepaymentLabel: UILabel!
    @IBOutlet weak var repaymentDescriptionLabel: UILabel!
    
    @IBOutlet weak var loanLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    
    private var terms: Int = 1
    private var interestRate: Float = 0
    private var loan: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loanSliderChanged(_ loanSlider: UISlider) {
        loan = loanSlider.value
        loanLabel.text = "£\(Utility.getFormattedNumber(loan, decimalPoints: 0))"
        calculateRepayment()
    }
    
    @IBAction func interestSliderChanged(_ interestSlider: UISlider) {
        interestRate = Float(interestSlider.value)
        interestLabel.text = "\(String(format: "%.2f", interestRate))%"
        calculateRepayment()
    }
    
    @IBAction func termSliderChanged(_ termSlider: UISlider) {
        terms = Int(termSlider.value)
        termsLabel.text = "\(terms) yr" + (terms != 1 ? "s" : "")
        calculateRepayment()
    }
    
    private func calculateRepayment() {
        var payment: Float = 0.0
        
        let r = (interestRate / 100) / 12
        let P = loan
        let n = terms * 12

        if P == 0 {
            payment = 0
            repaymentDescriptionLabel.text = "No repayment due"
        } else {
            if r == 0 {
                payment = P / Float(n)
            } else {
                let rn = pow(1 + r, Float(n))
                payment = P * (r * rn) / (rn - 1)
            }
            
            repaymentDescriptionLabel.text = "£\(Utility.getFormattedNumber(payment * Float(n))) over \(terms) year" + (terms > 1 ? "s" : "")
        }
        
        monthlyRepaymentLabel.text = "£\(Utility.getFormattedNumber(payment)) / mo."
    }
}
