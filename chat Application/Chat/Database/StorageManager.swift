//
//  StorageManager.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
import FirebaseStorage


final class StorageManager{
    
    static let shared = StorageManager()

    private let storage = Storage.storage().reference()
    private init(){
        
    }

    /*
     /images/santhosh-gmail-com_profile_picture.png
     
     */
    public typealias uploadPictureCompletion = ((Result<String,Error>)->Void)

    public func uploadProfilePicture(with data: Data? , fileName: String , completion: @escaping  uploadPictureCompletion ){
        guard let data = data else{
            completion(.failure(DatabaseModel.StorageError.failedToUpload))
            return 
        }
        let path = storage.child("images/\(fileName)")
        path.putData(data){
            metadata,error in
            guard  error == nil else{
                completion(.failure(DatabaseModel.StorageError.failedToUpload))
                return
            }
            
           path.downloadURL {
                url, error in
                guard let url = url
                else {
                    completion(.failure(DatabaseModel.StorageError.failedToGetDownloadUrl))
                    return
                
                }
                
                let urlString = url.absoluteString
                print(urlString)
                completion(.success(urlString))
            }
        }
       
    }
    
    public func downloadProfilePictureUrl(fileName:String,
                                          completion: @escaping uploadPictureCompletion){
        
        let path = storage.child("images/\(fileName)")
        
        path.downloadURL { url, error in
            
            guard let url = url
            else {
                completion(.failure(DatabaseModel.StorageError.failedToGetDownloadUrl))
                return
            
            }
            
            let urlString = url.absoluteString
            completion(.success(urlString))
            
        }
        
        
    }
    
    
    
    
}
