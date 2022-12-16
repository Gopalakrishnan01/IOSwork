//
//  ChatModel.swift
//  Chat
//
//  Created by zs-mac-6 on 30/11/22.
//

import Foundation

struct ChatModel{
    
    struct FetchResponse{
        
        struct chat{
            let id:String
            let name:String
            let otherUserPhoneNumber:String
            let latestMessage:LatestMessage
        }
        
        struct LatestMessage{
            let date:String
            let text:String
            let isRead:Bool
        }
    }
    
    
    struct ViewModel{
        
    }
    
    
    
}
