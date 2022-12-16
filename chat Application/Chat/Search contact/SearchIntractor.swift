//
//  SearchIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
import Contacts
import CoreData

protocol SearchBusinessLogic:AnyObject{
    
    func filterContacts(_ contacts:[NSManagedObject]?,text: inout String)
    
}

class SearchIntractor: SearchBusinessLogic{
    
    var presentor: SearchPresentationLogic!
    
    
    func filterContacts(_ contacts:[NSManagedObject]?,text: inout String){
        
        
        guard var selfPhoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String
            
        else{
            return 
        }
        
        let result = contacts?.compactMap({
            managedObject in
            
            if var name = managedObject.value(forKey:"name") as? String,
               let phoneNumber = managedObject.value(forKey: "phoneNumber") as? String {
                name = name.replacingOccurrences(of: " ", with: "").lowercased()
                
                selfPhoneNumber = selfPhoneNumber.replacingOccurrences(of: " ", with: "")
                 
                text = text.replacingOccurrences(of: " ", with: "").lowercased()
                if name.contains(text ), phoneNumber != selfPhoneNumber{
                    
                    return managedObject
                }
                
            }
            
           return nil
        })
        presentor.filtredContacts(result)
        
    }
    
}

