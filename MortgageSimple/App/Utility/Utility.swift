//
//  Utility.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 22/05/2023.
//

import Foundation

class Utility {
    static func getFormattedNumber(_ number: Float, decimalPoints: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimalPoints
        numberFormatter.minimumFractionDigits = decimalPoints
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0.00"
    }
}
