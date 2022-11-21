//
//  HeadlineIntractor.swift
//  News
//
//  Created by zs-mac-6 on 07/11/22.
//

import Foundation

protocol HeadlineBusinessLogic:AnyObject{
    var country:String { get set }
    func getTopHeadlines()
    func getCategoryRelated()
    func search(_ relatedTo:String)
    func fetchImage(with data: String?,completion: @escaping (Data,String)->Void,failure: @escaping (Error?)->Void)
    
    
}
class HeadlineIntractor:HeadlineBusinessLogic{
    
    var country: String = ""
    
   
    var presentor:HeadlinePresentationLogic!
    
    
    
    var fetchedImages = [String : Data]()
    
     func getTopHeadlines(){
        
        guard let topHeadlineURL=URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&apiKey=\(HeadlineModel.FetchResponse.apiKey)") else{
            return
        }
        URLSession.shared.dataTask(with: topHeadlineURL) { data, response, error in
            
            guard let data=data, error == nil else{
                return
            }
            let response=HeadlineModel.FetchResponse.HeadlineData(data: data)
            self.presentor.presentHeadline(response: response)
            
        }.resume()
        
    }

    

    func search(_ relatedTo:String){
        let topic=relatedTo.replacingOccurrences(of: " ", with: "")
        guard let categoryUrl=URL(string: "https://newsapi.org/v2/everything?q=\(topic)&ln=en&from=2022-11-15&sortBy=popularity&apiKey=\(HeadlineModel.FetchResponse.apiKey)") else{
            return
        }
        URLSession.shared.dataTask(with: categoryUrl) { data, response, error in
            
            guard let data=data, error == nil else{
                return
            }
            print(data)
            let response=HeadlineModel.FetchResponse.HeadlineData(data: data)
            self.presentor.presentHeadline(response: response)
            
        }.resume()
    }
    

    
    
     func getCategoryRelated(){
        
        guard let categoryUrl=URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&category=business&apiKey=\(HeadlineModel.FetchResponse.apiKey)") else{
            return
        }
        URLSession.shared.dataTask(with: categoryUrl) { data, response, error in
            
            guard let data=data, error == nil else{
                return
            }
            print(data)
            let response=HeadlineModel.FetchResponse.HeadlineData(data: data)
            self.presentor.presentHeadline(response: response)
            
        }.resume()
        
    }
    //FileManager
    
    func fetchImage(with urlToImage: String? ,completion: @escaping (Data,String)->Void,failure: @escaping (Error?)->Void) {
     
        if let link = urlToImage {
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
    
    
}

