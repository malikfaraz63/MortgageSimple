//
//  ChatViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 30/06/2023.
//

import UIKit
import MessageKit

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}
public struct Message: MessageType {
    public var sender: MessageKit.SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKit.MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource {
    var messages: [MessageType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        messageInputBar.sendButton.onTouchUpInside { _ in
            self.messages.append(Message(sender: self.currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: .attributedText(NSAttributedString(string: self.messageInputBar.inputTextView.text))))
            
            self.messageInputBar.inputTextView.text = ""
            self.messagesCollectionView.reloadData()
        }
    }
    
    var currentSender: MessageKit.SenderType {
        return Sender(senderId: "any_unique_id", displayName: "Steven")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
}
