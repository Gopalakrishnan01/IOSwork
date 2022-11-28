//
//  DatabaseManager.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    
    static let shared=DatabaseManager()
    
    private let database = Database.database().reference()
   
    private init(){
        
    }
   
    public typealias fetchUserCompletion =  (Result<NSDictionary,Error>)->Void
    
    func insertUser(with user: DatabaseModel.UserInfo,completion: @escaping (Bool)->Void){
        
        database.child("\(String(describing: user.phoneNumber))")
            .setValue(["name":user.name]) { error, _ in
                guard error == nil
                else{
                    completion(false)
                    return
                }
                
                self.database.child("users").observeSingleEvent(of: .value) { snapshot, _ in
                    
                    if var usersCollection = snapshot.value as? [[String:String]]{
                        //append to user array
                        let newElement = [ "name":user.name,
                                           "phoneNumber":user.phoneNumber]
                        usersCollection.append(newElement)
                        self.database.child("users").setValue(usersCollection ) {
                            error, _ in
                            guard error == nil
                            else{
                                completion(false)
                                return
                            }
                            completion(true)
                        }
                    }
                    else{
                        //create user array
                        let newCollection: [[String:String]] = [
                            [ "name":user.name,
                            "phoneNumber":user.phoneNumber]
                        
                        ]
                        self.database.child("users").setValue(newCollection) { error, _ in
                            guard error == nil
                            else{
                                completion(false)
                                return
                            }
                            completion(true)
                        }
                    }
                }
                
                
                
                completion(true)
            }
        
    }
    
    
    public func getUserDetails(with phoneNumber: String,
                               completion: @escaping fetchUserCompletion){
        database.child("\(String(describing: phoneNumber))").getData {
            error, snapshot in
            
            guard snapshot != nil ,  error == nil
            else{
                completion(.failure(SearchModel.FetchError.NoUserFound))
                return
            }
            guard let resultDictionary = snapshot?.value as? NSDictionary
            else{
                completion(.failure(SearchModel.FetchError.FailedToFetch))
                return
            }
            completion(.success(resultDictionary))
            
        }
    }
}
