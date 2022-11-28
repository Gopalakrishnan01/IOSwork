//
//  SearchPresentor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation

protocol SearchPresentationLogic:AnyObject{
    
    func presentSearchContact(response: SearchModel.FetchResponse.SearchData)
}

class SearchPresentor: SearchPresentationLogic{
    
    weak var viewController: SearchViewControllerDisplayLogic!
    
    
    public  func presentSearchContact(response: SearchModel.FetchResponse.SearchData){
        
        
        let value = SearchModel.ViewModel.another(data: response.data)
        
        
        DispatchQueue.main.async {
            self.viewController.update(viewModel: value)
        }
        
        
        
        
        
    }
}
