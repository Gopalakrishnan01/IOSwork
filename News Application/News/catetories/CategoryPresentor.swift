//
//  CategoryPresentor.swift
//  News
//
//  Created by zs-mac-6 on 15/11/22.
//

import Foundation
protocol CategoryPresentationLogic:AnyObject{
    func presentHeadline(response: CategoryModel.FetchResponse.CategoryData!)
    
}

class CategoryPresentor:CategoryPresentationLogic{
    
    weak var viewController:CategoryDisplayLogic!
    
    func presentHeadline(response: CategoryModel.FetchResponse.CategoryData!){
        if let resp=response,let data=resp.data{
            print(data)
            if let decodeHeadline=try? JSONDecoder().decode(CategoryModel.ViewModel.self, from: data){
                
                DispatchQueue.main.async {
                    self.viewController.update(viewModel: decodeHeadline)
                }
            }
            else {
                print("error")
            }
        }
    }
    
    
}
