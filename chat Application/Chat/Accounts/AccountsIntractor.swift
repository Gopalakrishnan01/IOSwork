//
//  AccountsIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 08/12/22.
//

import Foundation
protocol AccountsBusinessLogic:AnyObject{
    func deleteChats()
}

class AccountsIntractor:AccountsBusinessLogic{
    
    
    var presentor:AccountsPresentationLogic!
    
    
    func deleteChats() {
        
        ChatsEntity.shared.fetchChats {
            result in
            switch result{
                
            case.success(let response):
                for value in response{
                    ChatsEntity.shared.delete(personObject: value)
                }
                self.presentor.updateAndLogOut()
            case.failure(let error):
                print(error)
                
            }
        }
        
    }
    
    
}
