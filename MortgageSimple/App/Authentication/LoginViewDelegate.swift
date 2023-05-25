//
//  LoginViewDelegate.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 23/05/2023.
//

import Foundation
import FirebaseAuth

protocol LoginViewDelegate {
    func userDidLogin(user: User)
}
