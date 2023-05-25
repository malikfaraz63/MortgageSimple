//
//  MortgageSettingsManager.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 24/05/2023.
//

import Foundation

class MortgageSettingsManager {
    static let defaults = UserDefaults.standard
    
    static func hasUser() -> Bool {
        return getUserID() != nil
    }
    
    static func getUserID() -> String? {
        return defaults.string(forKey: "documentID")
    }
    
    static func deleteUser() {
        defaults.removeObject(forKey: "documentID")
    }
}
