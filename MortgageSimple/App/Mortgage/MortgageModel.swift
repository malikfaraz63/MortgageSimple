//
//  MortgageModel.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 25/05/2023.
//

import Foundation

struct MortgageModel: Codable {
    let address: String
    let lender: String
    let loan: Int
    let mortgageDescription: String
    let rate: Float
    let rent: Int
    let start: Date
    let term: Int
}
