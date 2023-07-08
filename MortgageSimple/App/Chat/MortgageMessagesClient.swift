//
//  MortgageMessageClient.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 08/07/2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class MortgageMessagesClient {
    typealias MessagesLoadCompletion = (_ messages: [MortgageMessage]) -> Void
    typealias MessageSendCompletion = () -> Void
    
    private let db = Firestore.firestore()
    
    public func addMessagesListener(forUid uid: String, source: MortgageMessageSource, completion: @escaping MessagesLoadCompletion) {
        db
            .collection("users")
            .document(uid)
            .collection(source.rawValue)
            .addSnapshotListener { querySnapshot, error in
                if let snapshot = querySnapshot {
                    var messages: [MortgageMessage] = []
                    do {
                        try messages.append(contentsOf: snapshot.documents.map { try $0.data(as: MortgageMessage.self) } )
                    } catch let error {
                        print(error)
                    }
                    
                    completion(messages)
                } else if let error = error {
                    print(error)
                }
            }
    }
    
    public func sendMessage(forUid uid: String, message: MortgageMessage) {
        do {
            try db
                .collection("users")
                .document(uid)
                .collection(MortgageMessageSource.clientMessages.rawValue)
                .document()
                .setData(from: message) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}

enum MortgageMessageSource: String {
    case clientMessages
    case companyMessages
}

