//
//  HeadlinePresentor.swift
//  News
//
//  Created by zs-mac-6 on 07/11/22.
//

import Foundation
protocol HeadlinePresentationLogic:AnyObject{
    
    func presentHeadline(response: HeadlineModel.FetchResponse.HeadlineData)
    
    
}
class HeadlinePresentor:HeadlinePresentationLogic{

    
    weak var viewController:HeadlineDisplayLogic!
    
    func presentHeadline(response: HeadlineModel.FetchResponse.HeadlineData){
        let resp=response
        if let data=resp.data{
            if let decodeHeadline=try? JSONDecoder().decode(HeadlineModel.ViewModel.self, from: data){
                
                DispatchQueue.main.async {
                    self.viewController.update(viewModel: decodeHeadline)
                }
                
            }
            
        }
            
            
    }
    
   
    
    
}
