//
//  ConversationModel.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
import MessageKit

struct Message : MessageType{
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    
}


struct Sender: SenderType {
    
    var photo: String
    var senderId: String
    var displayName: String
}
