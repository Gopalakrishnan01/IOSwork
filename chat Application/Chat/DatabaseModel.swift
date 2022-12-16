//
//  DatabaseModel.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import Foundation

struct DatabaseModel{
    
    
    struct UserInfo{
        var name:String
        var phoneNumber:String
        var profilePictureFileName:String{
            return "\(phoneNumber)_profile_picture.png"
        }
    }
    
    
    enum StorageError:Error{
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    enum DatabaseError:Error{
        case FailedToFetch
        case NoUserFound
    }
    
}
