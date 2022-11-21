//
//  CategoryIntractor.swift
//  News
//
//  Created by zs-mac-6 on 15/11/22.
//

import Foundation
protocol CategoryBusinessLogic:AnyObject{
    var category: String?{ get set }
    func categoryTopNews()
    func fetchImage(with url: String?,completion: @escaping (Data,String)->Void,failure: @escaping (Error?)->Void)
    
}
class CategoryIntractor:CategoryBusinessLogic{
    
    
    
    var presentor:CategoryPresentationLogic!
    
    
    var category:String?
    
    
    var fetchedImages = [String : Data]()
    
    func categoryTopNews(){
        guard let category=category else{ return }
        
        guard let topHeadlineURL=URL(string: "https://newsapi.org/v2/everything?q=\(category)&ln=en&sortBy=popularity&apiKey=\(CategoryModel.FetchResponse.apiKey)") else{ return }
        URLSession.shared.dataTask(with: topHeadlineURL) { data, response, error in
            
            guard let data=data, error == nil else{
                return
            }
            let response=CategoryModel.FetchResponse.CategoryData(data: data)
            self.presentor.presentHeadline(response: response)
            
        }.resume()
        
    }
    
    
    
    func fetchImage(with url: String? ,completion: @escaping (Data,String)->Void,failure: @escaping (Error?)->Void) {
        
        if let link = url {
            
            if let alreadyFetchedImage = fetchedImages[link]{
                completion(alreadyFetchedImage,link)
            }else{
                guard let url=URL(string: link ) else{
                    failure(nil)
                    return
                }
                
                URLSession.shared.dataTask(with: url) {
                    data, response, error in
                    DispatchQueue.main.async {
                        if let data=data, error == nil{
                            self.fetchedImages[link] = data
                            completion(data,link)
                        }
                        else{
                            failure(error!)
                        }
                    }
                    
                    
                }.resume()
            }
        }
        
        
    }
    
    
    func getDate()->String{
        let todayDate=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-mm-dd"
        return dateFormatter.string(from: todayDate)
    }
    
    
    
    
}
