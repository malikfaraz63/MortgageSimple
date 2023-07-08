//
//  MessageViewModel.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 07/07/2023.
//

import Foundation
import MessageKit

class MessageViewModel: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
    init(from message: MortgageMessage, sender: SenderType) {
        self.sender = sender
        self.messageId = message.sent.description
        self.sentDate = message.sent
        self.kind = .text(message.message)
    }
}
