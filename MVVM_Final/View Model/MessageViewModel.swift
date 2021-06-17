//
//  MessageViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class MessageViewModel: NSObject {
    private var apiService: ApiService!
    
    private(set) var errorMessage: String! {
        didSet {
            self.bindMessageViewModelToController()
        }
    }
    
    var bindMessageViewModelToController: (() -> ()) = {}
    
    init(_ message: String) {
        super.init()
        self.apiService = ApiService()
        self.callSendMessageToFirebase(message: message)
    }
}
extension MessageViewModel {
    private func callSendMessageToFirebase(message: String) {
         self.apiService.sendMessageToFirebase(message: message) { (error) in
             self.errorMessage = error
         }
     }
}
