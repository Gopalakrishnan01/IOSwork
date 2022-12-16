//
//  SearchModel.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
import Contacts

struct SearchModel{
    
    struct FetchResponse{
        struct ValidContacts{
            var name:String
            var phoneNumber:String
        }
    }
    
    struct ViewModel{
        
        struct FilteredContact{
            var name:String
            var phoneNumber:String
        }
        
    }
    
    
    
    
}
