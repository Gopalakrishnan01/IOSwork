//
//  DatabaseManager.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    
    static let shared=DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init(){
        
    }
    
    public typealias fetchUserCompletion =  (Result<String,Error>)->Void
    public typealias isValidUserCompletion = (Result<Bool,Error>)->Void
    
    func insertUser(with user: DatabaseModel.UserInfo,completion: @escaping (Bool)->Void){
        
        database.child("\(String(describing: user.phoneNumber))")
            .setValue(["name":user.name]) { error, _ in
                guard error == nil
                else{
                    completion(false)
                    return
                }
                
                self.database.child("users").observeSingleEvent(of: .value) { snapshot, _ in
                    
                    if var usersCollection = snapshot.value as? [[String:String]]{
                        //append to user array
                        let newElement = [ "name":user.name,
                                           "phoneNumber":user.phoneNumber]
                        usersCollection.append(newElement)
                        self.database.child("users").setValue(usersCollection ) {
                            error, _ in
                            guard error == nil
                            else{
                                completion(false)
                                return
                            }
                            completion(true)
                        }
                    }
                    else{
                        //create user array
                        let newCollection: [[String:String]] = [
                            [ "name":user.name,
                              "phoneNumber":user.phoneNumber]
                            
                        ]
                        
                        self.database.child("users").setValue(newCollection) { error, _ in
                            guard error == nil
                            else{
                                completion(false)
                                return
                            }
                            completion(true)
                        }
                    }
                }
                
                
                
                completion(true)
            }
        
    }
    
    
    public func getUserDetails(with phoneNumber: String,
                               completion: @escaping fetchUserCompletion){
        database.child("\(phoneNumber)").getData{
            error,snapshot in
            
            if snapshot?.value is [[String:String]]{
                completion(.failure(DatabaseModel.DatabaseError.NoUserFound))
            }
            else{
                
                let resultDictionary = snapshot?.key
                completion(.success((resultDictionary)!))
            }
            
        }
    }
    
    
    public func isValidUser(with phoneNumber:String,
                            completion: @escaping isValidUserCompletion){
        
        database.child("\(phoneNumber)").observeSingleEvent(of: .value) {
            snapshot in
            
            guard snapshot.exists() else {
                completion(.failure(DatabaseModel.DatabaseError.NoUserFound))
                return
            }
            completion(.success(true))
        }
        
        
        
    }
    
}


extension DatabaseManager{
    
    ///create new conversation wtih target user phoneNumber and first message sent
    public func createNewConversation(name:String,with phoneNumber:String,
                                      firstMessage:ConversationModel.Message,
                                      completion: @escaping (Bool)->Void){
        guard let currentPhoneNumber =  UserDefaults.standard.value(forKey: "phoneNumber") as? String ,
              let currentUserName = UserDefaults.standard.value(forKey: "userName") as? String
                
        else{
            completion(false)
            return
        }
        database.child("\(currentPhoneNumber)").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String:Any]
            else{
                print("user not found")
                completion(false)
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ConversationModel.dateFormatter.string(from: messageDate)
            let conversationId = "conversations_\(firstMessage.messageId)"
            
            var message = ""
            switch(firstMessage.kind){
                
            case .text(let messageText):
                message=messageText
                break
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            let newConversation:[String:Any] = [
                "id":conversationId,
                "other_user_phoneNumber":phoneNumber,
                "name":name,
                "latest_message":[
                    "date":dateString,
                    "message":message,
                    "is_read": false
                ]
            ]
            let recipient_newConversation:[String:Any] = [
                "id":conversationId,
                "other_user_phoneNumber":currentPhoneNumber,
                "name":currentUserName,
                "latest_message":[
                    "date":dateString,
                    "message":message,
                    "is_read":false
                ]
            ]
            // update receipient conversation entry
            self?.database.child("\(phoneNumber)/conversations").observeSingleEvent(of: .value) {
                [weak self] snapshot in
                if var conversations = snapshot.value as? [[String:Any]]{
                    // append new conversation
                    conversations.append(recipient_newConversation)
                    self?.database.child("\(phoneNumber)/conversations").setValue(conversations)
                }
                else{
                    // create new conversation
                    self?.database.child("\(phoneNumber)/conversations").setValue([recipient_newConversation])
                    
                }
                
            }
            
            
            // update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String:Any]]{
                //converstion array exists
                conversations.append(newConversation)
                userNode["conversations"]=conversations
                self?.database.child("\(currentPhoneNumber)").setValue(userNode) { [weak self] error , _ in
                    guard error == nil
                    else{
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name:name,
                                                     conversationId:conversationId,
                                                     firstMessage: firstMessage){
                        result in
                        completion(true)
                    }
                    
                }
            }
            else{
                //conversation arrray does not exist
                userNode["conversations"] = [
                    newConversation
                ]
                
                self?.database.child("\(currentPhoneNumber)").setValue(userNode) { [weak self] error , _ in
                    guard error == nil
                    else{
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name:name,
                                                     conversationId:conversationId,
                                                     firstMessage: firstMessage){
                        result in
                        if result{
                            completion(true)
                            return
                        }
                        completion(false)
                    }
                    
                }
            }
            
        }
    }
    
    private func finishCreatingConversation(name:String,
                                            conversationId:String,
                                            firstMessage:ConversationModel.Message,
                                            completion: @escaping (Bool)->Void){
        
        guard let currentPhoneNumber =  UserDefaults.standard.value(forKey: "phoneNumber") as? String else{
            completion(false)
            return
        }
        let messageDate = firstMessage.sentDate
        let dateString = ConversationModel.dateFormatter.string(from: messageDate)
        
        
        var message = ""
        switch(firstMessage.kind){
            
        case .text(let messageText):
            message=messageText
            break
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let collectionMessage: [String:Any] = [
            "id":firstMessage.messageId,
            "type":firstMessage.kind.messageKindString,
            "content":message,
            "date":dateString,
            "name":name,
            "sender_phoneNumber":currentPhoneNumber,
            "is_read":false
            
        ]
        
        
        let value: [String:Any] = [
            "message":[collectionMessage]
        ]
        
        
        database.child("\(conversationId)").setValue(value) {
            error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            completion(true)
        }
        
        
    }
    
    ///fetchs and return all chat for the user with phoneNumber
    public func getAllChats(for phoneNumber: String,
                            completion: @escaping(Result<[ChatModel.FetchResponse.chat],Error>)->Void){
        
        
        database.child("\(phoneNumber)/conversations").observe(.value) {
            snapshot in
            
            guard let value = snapshot.value as? [[String:Any]] else{
                completion(.failure(DatabaseModel.DatabaseError.FailedToFetch))
                return
            }
            let chats:[ChatModel.FetchResponse.chat] = value.compactMap {
                dictionary in
                
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserPhoneNumber = dictionary["other_user_phoneNumber"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String:Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool
                else{
                    return nil
                }
                
                let latestMessageObject = ChatModel.FetchResponse.LatestMessage(date:date,
                                                                  text: message, isRead: isRead)
                return ChatModel.FetchResponse.chat(id: conversationId,
                                      name: name,
                                      otherUserPhoneNumber: otherUserPhoneNumber,
                                      latestMessage: latestMessageObject)
                
            }
            
            completion(.success(chats))
        }
        
    }
    
    ///gets all messages for given conversation
    public func getAllMessagesForConversation(for id:String,completion: @escaping(Result<[ConversationModel.Message],Error>)->Void){
        
        
        database.child("\(id)/message").observe(.value) {
            snapshot in
            
            guard let value = snapshot.value as? [[String:Any]] else{
                completion(.failure(DatabaseModel.DatabaseError.FailedToFetch))
                return
            }
            let messages:[ConversationModel.Message] = value.compactMap {
                dictionary in
                
                guard let name = dictionary["name"] as? String,
                      let sender_phoneNumber = dictionary["sender_phoneNumber"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let content = dictionary["content"] as? String,
                      let messageId = dictionary["id"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let type = dictionary["type"] as? String,
                      let date = ConversationModel.dateFormatter.date(from: dateString) else {
                    return nil
                }
                
                
                let sender = ConversationModel.Sender(photoUrl: "", senderId: sender_phoneNumber, displayName: name)
                return ConversationModel.Message(sender: sender, messageId: messageId, sentDate: date , kind: .text(content))
                
            }
            
            completion(.success(messages))
        }
    }
    // sends a message with target conversation and message
    public func sendMessage(to conversation:String , otherUserPhoneNumber:String,
                            name:String,messages: ConversationModel.Message,
                            completion: @escaping (Bool)->Void ){
        
        self.database.child("\(conversation)/message").observeSingleEvent(of: .value) {
            [weak self ]snapshot in
            
            guard let strongSelf = self else{
                return
            }
            
            guard var currentMessages = snapshot.value as? [[String:Any]],
                  let currentPhoneNumber =  UserDefaults.standard.value(forKey: "phoneNumber") as? String
            else{
                completion(false)
                return
            }
            
            
            let messageDate = messages.sentDate
            let dateString = ConversationModel.dateFormatter.string(from: messageDate)
            
            
            var message = ""
            switch(messages.kind){
                
            case .text(let messageText):
                message=messageText
                break
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let newMessageEntry : [String:Any ] = [
                "id":messages.messageId,
                "type":messages.kind.messageKindString,
                "content":message,
                "date":dateString,
                "name":name,
                "sender_phoneNumber":currentPhoneNumber,
                "is_read":false
                
            ]
            currentMessages.append(newMessageEntry)
            
            strongSelf.database.child("\(conversation)/message").setValue(currentMessages) {
                error, _ in
                guard error == nil else{
                    return
                }
                
                
                strongSelf.database.child("\(currentPhoneNumber)/conversations").observeSingleEvent(of: .value) {
                    snapshot in
                    
                    guard var currentUserConversations = snapshot.value as? [[String:Any]] else{
                        completion(false)
                        return
                    }
                    let updateValue :[String:Any] = [
                        "date":  dateString,
                        "message": message,
                        "is_read": false
                    ]
                    var targetConversation:[String:Any]?
                    var position = 0
                    for conversationDictionary in currentUserConversations {
                        if let databaseConversationId = conversationDictionary["id"] as? String,
                           databaseConversationId ==  conversation {
                            targetConversation = conversationDictionary
                            break
                        }
                        position+=1
                    }
                    
                    targetConversation?["latest_message"] = updateValue
                    guard let finalConversation  = targetConversation else{
                        completion(false)
                        return
                    }
                    currentUserConversations[position] = finalConversation
                    
                    strongSelf.database.child("\(currentPhoneNumber)/conversations").setValue(currentUserConversations) {
                        error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        /// update latest message for recepient user
                        strongSelf.database.child("\(otherUserPhoneNumber)/conversations").observeSingleEvent(of: .value) {
                            snapshot in
                            
                            guard var otherUserConversation = snapshot.value as? [[String:Any]] else{
                                completion(false)
                                return
                            }
                            let updateValue :[String:Any] = [
                                "date":  dateString,
                                "message": message,
                                "is_read": false
                            ]
                            var targetConversation:[String:Any]?
                            var position = 0
                            for conversationDictionary in otherUserConversation {
                                if let databaseConversationId = conversationDictionary["id"] as? String,
                                   databaseConversationId ==  conversation {
                                    targetConversation = conversationDictionary
                                    break
                                }
                                position+=1
                            }
                            
                            targetConversation?["latest_message"] = updateValue
                            guard let finalConversation  = targetConversation else{
                                completion(false)
                                return
                            }
                            otherUserConversation[position] = finalConversation
                            
                            strongSelf.database.child("\(otherUserPhoneNumber)/conversations").setValue(otherUserConversation ) {
                                error, _ in
                                guard error == nil else{
                                    completion(false)
                                    return
                                }
                                completion(true)
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
}
