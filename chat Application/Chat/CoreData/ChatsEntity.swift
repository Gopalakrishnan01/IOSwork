//
//  ChatsEntity.swift
//  Chat
//
//  Created by zs-mac-6 on 07/12/22.
//

import Foundation
import CoreData

final class ChatsEntity:NSObject{
    
    
    static let shared = ChatsEntity()
    
    private override init(){
        
    }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ChatModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func createChat(name: String, phoneNumber:String, conversationId:String	, isRead:Bool, text:String, url:String){
        
        
        let context = persistentContainer.viewContext
       
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Chats", in: context) else { return }
        
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Chats")
        fetchRequest.predicate = NSPredicate(format: "otherUserPhoneNumber = %@", phoneNumber)
        
        do{
            
            let isPresent = try context.fetch(fetchRequest)
            if isPresent.count == 1{
                let object = isPresent[0] as! NSManagedObject
                object.setValue(name, forKey: "name")
                object.setValue(phoneNumber, forKey: "otherUserPhoneNumber")
                object.setValue(conversationId,forKey: "id")
                object.setValue(text, forKey: "latestMessageText")
                object.setValue(isRead, forKey: "latestMessageIsRead")
                object.setValue(url, forKey: "imageUrl")
                
            }else{
                let managedObject = NSManagedObject(entity: entityDescription, insertInto: context)
                managedObject.setValue(name, forKey: "name")
                managedObject.setValue(phoneNumber, forKey: "otherUserPhoneNumber")
                managedObject.setValue(conversationId, forKey: "id")
                managedObject.setValue(text, forKey: "latestMessageText")
                managedObject.setValue(isRead, forKey: "latestMessageIsRead")
                managedObject.setValue(url, forKey: "imageUrl")
            }
            
        }
        catch{
            print("failed to create chat")
        }
        
        
        saveContext()
        
        
    }
    
    
    
    public func fetchChats(completion: @escaping(Result<[NSManagedObject],Error>)->Void){
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chats")
        do{
            guard let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
            else{
                completion(.failure(ChatDatabaseError.failedToFetch))
                return 
            }
            completion(.success(result ))
        }
        
    }
    
    
    func delete(personObject: NSManagedObject){
      
        persistentContainer.viewContext.delete(personObject)
        saveContext()
        
    }
    
    public func updateUrl(url:String,phoneNumber:String){
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Chats")
        fetchRequest.predicate = NSPredicate(format: "otherUserPhoneNumber = %@", phoneNumber)
        
        do{
            let isPresent = try context.fetch(fetchRequest)
            if isPresent.count == 1{
                guard let object = isPresent[0] as? NSManagedObject
                else{
                    return
                }
                object.setValue(url,forKey: "imageUrl")
            }
        }
        catch{
            print("failed to update url")
        }
        
        
    }
    
    enum ChatDatabaseError:Error{
        case failedToFetch
    }
    
}
