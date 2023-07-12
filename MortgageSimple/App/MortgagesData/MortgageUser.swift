//
//  MortgageSimpleUser.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 23/05/2023.
//

import Foundation

struct MortgageUser: Codable {
    let address: String
    let age: Int
    let name: String?
    let email: String?
    let phone: String
    let photoURL: String?
    let clientUnread: Int
}
