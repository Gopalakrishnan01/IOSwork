//
//  SearchIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation

protocol SearchBusinessLogic:AnyObject{
    func fetchUsers(phoneNumbers:[String])
}

class SearchIntractor: SearchBusinessLogic{
    
    var presentor: SearchPresentationLogic!
    
    
    func fetchUsers(phoneNumbers:[String]) {
        
        for phoneNumber in phoneNumbers{
            DatabaseManager.shared.getUserDetails(with: phoneNumber) { result in
                
                switch(result){
                case .success(let value):
                    let response = SearchModel.FetchResponse.SearchData(data: value as! [String:String])
                    self.presentor.presentSearchContact(response: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
}
