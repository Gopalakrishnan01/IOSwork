//
//  ProfileAndSettingsHeaderIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 26/11/22.
//

import Foundation
protocol ProfileAndSettingsHeaderBussinessLogic:AnyObject{
    func fetchImage(with url:String?,completion: @escaping (Result<Data,Error>)->Void)
    
}

class  ProfileAndSettingsHeaderIntractor: ProfileAndSettingsHeaderBussinessLogic{
    
    var presentor: ProfileAndSettingsHeaderPresentationLogic!
    
    public typealias downloadPictureCompletion = (Result<Data,Error>)->Void
    
    public func fetchImage(with url: String?,completion: @escaping downloadPictureCompletion) {
            
        guard let url = url else {
            completion(.failure(ProfileAndSettingsHeaderModel.FetchResponse.DownloadError.urlInvalid))
            return
        }
        guard let imageUrl = URL(string: url)
        else {
            completion(.failure(ProfileAndSettingsHeaderModel.FetchResponse.DownloadError.urlInvalid))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: imageUrl)) { data, response, error in
            
            guard let data = data , error == nil
            else {
                completion(.failure(ProfileAndSettingsHeaderModel.FetchResponse.DownloadError.failedToDownload))
                return
                
            }
            completion(.success(data))
            
            
            
         }.resume()
        
        
    }
    
}
