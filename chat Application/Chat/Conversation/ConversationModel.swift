//
//  ConversationModel.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
import MessageKit
struct ConversationModel{
    
    public static var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    struct Message : MessageType{
        
        public var sender: SenderType
        public var messageId: String
        public var sentDate: Date
        public var kind: MessageKind
        
        
    }
    struct Sender: SenderType {
        
        public var photoUrl: String
        public var senderId: String
        public var displayName: String
    }
    
}


extension MessageKind {
    var messageKindString: String{
        switch self{
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}
