//
//  ChatIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import Foundation
import CoreData

protocol ChatBusinessLogic:AnyObject{
    
    func getChats()
    
    func startListeningForChats()
    
    func downloadProfileImageUrl(fileName:String,completion:@escaping (String)->Void)
    
    func updateProfileImageUrl(Path:String,model:NSManagedObject)
}

class ChatIntractor:ChatBusinessLogic{
    
    
    var presentor:ChatPresentationLogic!
    
    
    func getChats(){
        
        ChatsEntity.shared.fetchChats(){
            result in
            switch result{
            case .success(let result):
                self.presentor.presentChats(result)
            case .failure(let error):
                print(error)
            }
        }
        
    }

    
    
    func startListeningForChats(){
        guard let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String
        else{
            return
        }
        DatabaseManager.shared.getAllChats(for: phoneNumber) {
            [weak self] result in
            guard let strongSelf = self else { return  }
            
            switch(result){
            case .success(let chats):
                guard !chats.isEmpty
                else{
                    return
                }
                strongSelf.createChat(chats)
                strongSelf.getChats()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func downloadProfileImageUrl(fileName:String,completion:@escaping (String)->Void){
        
        StorageManager.shared.downloadProfilePictureUrl(fileName: fileName) { result in
            switch result{
            case.success(let url):
                completion(url)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func updateProfileImageUrl(Path: String,model:NSManagedObject) {
        guard let phoneNumber = model.value(forKey: "otherUserPhoneNumber") as? String
        else{
            return
        }
        PersonEntity.shared.updateUrl(url: Path, phoneNumber: phoneNumber)
        ChatsEntity.shared.updateUrl(url: Path, phoneNumber: phoneNumber)
        
    }
    
    /// store chats local
    private func createChat(_ model: [ChatModel.FetchResponse.chat]){
        
     
        
        for value in model  {
            
            if let url = PersonEntity.shared.fetchUrl(value.otherUserPhoneNumber){
                
                ChatsEntity.shared.createChat(name: value.name,
                                              phoneNumber:value.otherUserPhoneNumber,
                                              conversationId:value.id,
                                              isRead:value.latestMessage.isRead,
                                              text:value.latestMessage.text,
                                              url: url)
            }
        }
        
        
        
    }
    
    
    
    
    
   
    

}

