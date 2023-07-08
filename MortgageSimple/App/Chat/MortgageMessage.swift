//
//  MortgageMessage.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 07/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MortgageMessage: Codable {
    let message: String
    let sent: Date
    let read: Bool
    
    enum CodingKeys: String, CodingKey {
        case message
        case sent
        case read
    }
}
