//
//  ChatPresentor.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import Foundation
import CoreData
protocol ChatPresentationLogic:AnyObject{
    func presentChats(_ response:[NSManagedObject])
}

class ChatPresentor:ChatPresentationLogic{
   
    
    
    var viewController:ChatDisplayLogic!
    
    func presentChats(_ response:[NSManagedObject]) {
        DispatchQueue.main.async {
//            for value in response{
//                ChatsEntity.shared.delete(personObject: value)
//            }
            self.viewController.updateChats(response)
        }
    }
    
    
}
