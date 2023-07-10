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
    var previousUserID: String?
    
    var messages: [MessageType] = []
    var companyMessages: [MessageType] = []
    var clientMessages: [MessageType] = []
    let mortgageMessagesClient = MortgageMessagesClient()
    
    let client = Sender(senderId: "sender", displayName: "You")
    let company = Sender(senderId: "company", displayName: "Company")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
                
        messageInputBar.sendButton.onTouchUpInside { _ in self.sendMessage() }
        
        viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if MortgageSettingsManager.hasUser() {
            if let previousUserID = previousUserID {
                if MortgageSettingsManager.getUserID() != previousUserID {
                    self.previousUserID = MortgageSettingsManager.getUserID()
                    fetchMessages()
                }
            } else {
                previousUserID = MortgageSettingsManager.getUserID()
                fetchMessages()
            }
        } else {
            messages = []
            messagesCollectionView.reloadData()
        }
    }
    
    var currentSender: MessageKit.SenderType {
        return client
    }
    
    func sendMessage() {
        guard let uid = MortgageSettingsManager.getUserID() else { return }
        guard let message = messageInputBar.inputTextView.text else { return }
        if message.count == 0 {
            return
        }
        
        let mortgageMessage = MortgageMessage(message: messageInputBar.inputTextView.text, sent: Date(), read: false)
        
        mortgageMessagesClient.sendMessage(forUid: uid, message: mortgageMessage)
        
        messageInputBar.inputTextView.text = ""
    }
    
    func fetchMessages() {
        guard let uid = MortgageSettingsManager.getUserID() else { return }
        
        mortgageMessagesClient.addMessagesListener(forUid: uid, source: .clientMessages) { clientMessages in
            self.clientMessages.removeAll()
            
            for message in clientMessages {
                self.clientMessages.append(MessageViewModel(from: message, sender: self.client))
            }
            
            self.messages.removeAll()
            self.messages.append(contentsOf: self.clientMessages)
            self.messages.append(contentsOf: self.companyMessages)
            
            self.messages.sort { $0.sentDate < $1.sentDate }
            self.messagesCollectionView.reloadData()
            
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
        
        mortgageMessagesClient.addMessagesListener(forUid: uid, source: .companyMessages) { companyMessages in
            self.companyMessages.removeAll()
            
            for message in companyMessages {
                self.companyMessages.append(MessageViewModel(from: message, sender: self.company))
            }
            
            self.messages.removeAll()
            self.messages.append(contentsOf: self.clientMessages)
            self.messages.append(contentsOf: self.companyMessages)
            
            self.messages.sort { $0.sentDate < $1.sentDate }
            self.messagesCollectionView.reloadData()
            
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if (message.sender.senderId == client.senderId) {
            avatarView.isHidden = true
        } else {
            avatarView.image = UIImage(named: "companyAvatar")
            avatarView.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageInputBar.inputTextView.resignFirstResponder()
    }
}
