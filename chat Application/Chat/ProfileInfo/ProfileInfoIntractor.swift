//
//  ProfileInfoIntractor.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import Foundation
import Contacts

protocol ProfileInfoBusinessLogic:AnyObject{
    func fetchAllContacts()
    func createUser(userName:String?,_ profileImage:Data?)
}

class ProfileInfoIntractor: ProfileInfoBusinessLogic{
    
    
    
    var presentor: ProfileInfoPresentationLogic!
    
    
    func createUser(userName:String?,_ profileImage:Data?) {
        guard let name = userName,
              let profileImage = profileImage,
            let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String
        else{
            return
        }
        UserDefaults.standard.set(name, forKey: "userName")
        let userInfo =  DatabaseModel.UserInfo(name: name,phoneNumber:phoneNumber )
        DatabaseManager.shared.insertUser(with: userInfo){
            result in
            
        }
        let fileName = userInfo.profilePictureFileName
        StorageManager.shared.uploadProfilePicture(with: profileImage, fileName: fileName) {
            result in
            switch result {
            case .success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
            case .failure(let error):
                print("Storage Manager Error: \(error)" )
            }
        
        }
    }
    
    
    func fetchAllContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey,CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keys )
                results.append(contentsOf: containerResults)
                
            } catch {
                print("Error fetching containers")
            }
        }
        
        checkValidUser(results)
    }
    
    
    
    private func checkValidUser(_ results:[CNContact]){
        
        let count = results.count
        
        for value in results{
            
            let name = value.givenName
            let phoneNumbers = value.phoneNumbers.compactMap({ number in
                return number.value.stringValue
            })
            
            for phoneNumber in phoneNumbers {
                let number = phoneNumber.replacingOccurrences(of: "-", with: "")
                let modifiedNumber = number.replacingOccurrences(of: " ", with: "")
                
                DatabaseManager.shared.isValidUser(with: modifiedNumber) {
                    isValidUser in
                    switch isValidUser{
                    case .success(_):
                        let fileName = "\(modifiedNumber)_profile_picture.png"
                        StorageManager.shared.downloadProfilePictureUrl(fileName: fileName) {
                            result in
                            switch(result){
                            case .success(let path):
                                PersonEntity.shared.createPerson(name: name, phoneNumber: modifiedNumber,url:path)
                                if (results.last == value){
                                    self.presentor.validatedContact()
                                }
                            case .failure(_):
                                break
                            }
                            
                        }
                        
                    case .failure(_): break
                        
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
    
}
