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
    private var clientMessagesListener: ListenerRegistration?
    private var companyMessagesListener: ListenerRegistration?
    private var unreadCompanyMessageIds: [String] = []
    
    public func addMessagesListener(forUid uid: String, source: MortgageMessageSource, completion: @escaping MessagesLoadCompletion) {
        let listener = db
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
                    
                    if (source == .companyMessages) {
                        self.unreadCompanyMessageIds = snapshot.documents
                            .filter { !($0.data()["read"] as! Bool) }
                            .map { $0.documentID }
                    }
                    
                    completion(messages)
                } else if let error = error {
                    print(error)
                }
            }
        
        if (source == .clientMessages) {
            if let clientMessagesListener = clientMessagesListener {
                clientMessagesListener.remove()
            }
            clientMessagesListener = listener
        } else {
            if let companyMessagesListener = companyMessagesListener {
                companyMessagesListener.remove()
            }
            companyMessagesListener = listener
        }
    }
    
    public func getUnreadMessagesCount() -> Int {
        return unreadCompanyMessageIds.count
    }
    
    public func markCompanyMessagesRead(forUid uid: String) {
        if unreadCompanyMessageIds.isEmpty {
            return
        }
        
        let companyMessagesRef = db
            .collection("users")
            .document(uid)
            .collection(MortgageMessageSource.companyMessages.rawValue)
        
        for messageId in unreadCompanyMessageIds {
            companyMessagesRef
                .document(messageId)
                .updateData(["read": true]) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
        
        unreadCompanyMessageIds = []
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

