//
//  ConversationPresentor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation

protocol ConversationPresentationLogic:AnyObject{
    func presentAllMessagesForConversation(response: [ConversationModel.Message])
    
    func isMessageSent()
}
class ConversationPresentor:ConversationPresentationLogic{
    
    
    
    weak var viewController: ConversationDisplayLogic!
    
    
    func presentAllMessagesForConversation(response: [ConversationModel.Message]) {
        
        viewController.updateAllMessagesForConversation(viewModel: response)
        
    }
    
    
    func isMessageSent(){
        self.viewController.updateMessageSent()
    }
}
