//
//  CategoryModel.swift
//  News
//
//  Created by zs-mac-6 on 16/11/22.
//

import Foundation
struct CategoryModel{
    struct FetchResponse{
        
        static let apiKey="4b6dfa1f042840a49b334423f1bcc73f"
        static let categories=["Business","Sports","Entertainment","Technology","Science","Health"]
        struct CategoryData{
            var data:Data!
        }
        
       
        
    }
    
    struct ViewModel:Decodable{
        var articles:[Articles]
        struct Articles:Decodable{
            var title:String?
            var description:String?
            var url:String?
            var urlToImage:String?
        }
        
    }
}
