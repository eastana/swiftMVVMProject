//
//  ChatViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class ChatViewModel: NSObject {
    private var apiService: ApiService!
    
    private(set) var messages: [MessageEntity] = [] {
        didSet {
            self.bindChatViewModelToController()
        }
    }
    
    var bindChatViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService = ApiService()
        self.callFuncToGetMessages()
    }
    
    
}
extension ChatViewModel {
   private func callFuncToGetMessages() {
        self.apiService.fetchMessagesFromFirebase() { (messages) in
            self.messages.append(MessageEntity(message: messages.message, sender: messages.sender))
        }
    }
}
