//
//  ConversationIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
protocol ConversationBusinessLogic: AnyObject{
    func sendMessage(with message:ConversationModel.Message,
                     to name:String,with phoneNumber:String)
    func sendMessageToExistingChat(conversationId: String ,otherUserPhoneNumber:String,name:String,                                       message:ConversationModel.Message)
    func listenForMessage(id:String?)
}
class ConversationIntractor:ConversationBusinessLogic{
    
    
    
    
    var presentor:ConversationPresentationLogic!
    
    func sendMessage(with message:ConversationModel.Message,to name:String,with phoneNumber: String){
        
        DatabaseManager.shared.createNewConversation(name: name, with: phoneNumber, firstMessage: message) {
            result in
            if result {
                self.listenForMessage(id: "conversations_\(message.messageId)")
                self.presentor.isMessageSent()
            }
            else{
                print("failed to send message")
            }
        }
        
       
    }
    
    func sendMessageToExistingChat(conversationId: String ,otherUserPhoneNumber:String,
                                   name:String, message:ConversationModel.Message) {
        DatabaseManager.shared.sendMessage(to: conversationId, otherUserPhoneNumber: otherUserPhoneNumber, name: name, messages: message) { result in
            if result{
              print("message sent")
            }
            else{
             print("message failed to send")
            }
        }
        
        
    }
    
    func listenForMessage(id:String?){
        guard let id = id
        else {
            return
            
        }
        
        DatabaseManager.shared.getAllMessagesForConversation(for: id ) {
            [weak self] result  in
            switch(result){
            case .success(let messages):
                guard !messages.isEmpty
                else{
                    return
                }
                
                self?.presentor.presentAllMessagesForConversation(response: messages)
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }
    
   
    
    
}
