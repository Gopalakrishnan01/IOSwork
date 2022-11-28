//
//  SearchModel.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation


struct SearchModel{
    
    struct FetchResponse{
        
        
        struct SearchData{
            var data:[String:String]
        }
        
        
        
    }
    
    
    
    
    struct ViewModel{
        
        struct another{
            var data: [String:String]
        }
       
        
        
    }
    
    enum FetchError:Error{
        case FailedToFetch
        case NoUserFound
    }
    
    
}
