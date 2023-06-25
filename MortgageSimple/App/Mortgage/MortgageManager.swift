//
//  Mortgage.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 25/05/2023.
//

import Foundation

class MortgageManager {
    public static func getLenderLabel(forModel model: MortgageModel) -> String {
        return model.lender
    }
    
    public static func getDescriptionLabel(forModel model: MortgageModel) -> String {
        return model.mortgageDescription
    }
    
    public static func getRateLabel(forModel model: MortgageModel) -> String {
        let rateString = Utility.getFormattedNumber(model.rate * 100.0)
        
        return "\(rateString)%"
    }
    
    public static func getRepaymentLabel(forModel model: MortgageModel) -> String {
        let repaymentString = Utility.getFormattedNumber(calculateRepayment(forModel: model), decimalPoints: 0)
        return "£\(repaymentString) / mo."
    }
    
    public static func getRemainingLabel(forModel model: MortgageModel) -> String {
        let remainingRepayment = Float(getRemainingRepaymentTerms(forModel: model)) * calculateRepayment(forModel: model)
        
        let remainingString = Utility.getFormattedNumber(remainingRepayment, decimalPoints: 0)
        return "£\(remainingString)"
    }
    
    public static func getProgress(forModel model: MortgageModel) -> Float {
        let completedTerms = model.term * 12 - getRemainingRepaymentTerms(forModel: model)
        let completedPayment = Float(completedTerms) * calculateRepayment(forModel: model)
        
        return completedPayment / Float(model.loan)
    }
    
    private static func calculateRepayment(forModel model: MortgageModel) -> Float {
        let r = model.rate / 12
        let P = model.loan
        let n = model.term * 12
        
        var repayment: Float = 0
        if P != 0 {
            if r == 0 {
                repayment = Float (P / n)
            } else {
                let rn = pow(1 + r, Float(n))
                repayment = Float(P) * (r * rn) / (rn - 1)
            }
        }
        
        if repayment > Float(model.rent) {
            repayment -= Float(model.rent)
        } else {
            repayment = 0
        }
        
        return repayment
    }
    
    private static func getRemainingRepaymentTerms(forModel model: MortgageModel) -> Int {
        let start = model.start
        let current = Date()
        
        let interval = current.timeIntervalSince(start)
        
        let totalTerms = model.term * 12
        if interval < 0 {
            return totalTerms
        } else {
            let monthLength = 86400 * 30
            return totalTerms - Int(interval.magnitude) / monthLength
        }
    }
}
