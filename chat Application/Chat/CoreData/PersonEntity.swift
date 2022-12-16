//
//  PersonEntity.swift
//  Chat
//
//  Created by zs-mac-6 on 02/12/22.
//

import Foundation
import CoreData

final class PersonEntity:NSObject{
    
    static let shared = PersonEntity()
    
    
    private override init(){
       
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ContactModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
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
    
    
    
    
    public func createPerson(name:String,phoneNumber:String,url:String){
        let context = persistentContainer.viewContext
       
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "phoneNumber = %@", phoneNumber)
        do{
            let isPresent = try context.fetch(fetchRequest)
            if isPresent.count == 1{
                guard let object = isPresent[0] as? NSManagedObject
                else{
                    return
                }
                object.setValue(name, forKey: "name")
                object.setValue(phoneNumber, forKey: "phoneNumber")
                object.setValue(url,forKey: "url")
            }else{
                let managedObject = NSManagedObject(entity: entityDescription, insertInto: context)
                managedObject.setValue(name, forKey: "name")
                managedObject.setValue(phoneNumber, forKey: "phoneNumber")
                managedObject.setValue(url, forKey: "url")
            }
        }
        catch{
            print("failed to create person")
        }
        saveContext()
        
    }
    
    public func fetchPersons()->[NSManagedObject]{
        
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do{
            let result = try? context.fetch(fetchRequest)
            return result as! [NSManagedObject]
        }
        
    }
    
    public func fetchUrl(_ phoneNumber: String)->String?{
        
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "phoneNumber = %@", phoneNumber)
        
        do {
            let isPresent = try context.fetch(fetchRequest)
            if isPresent.count == 1{
                guard let managedObject = isPresent[0] as? NSManagedObject,
                      let result = managedObject.value(forKey: "url") as? String
                else{
                    return nil
                }
                return result
            }
           
        }
        catch{
            print("failed to fetch")
        }
        return nil
    }
    
    public func updateUrl(url:String,phoneNumber:String){
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "phoneNumber = %@", phoneNumber)
        
        do{
            let isPresent = try context.fetch(fetchRequest)
            if isPresent.count == 1{
                guard let object = isPresent[0] as? NSManagedObject
                else{
                    return
                }
                object.setValue(url,forKey: "url")
            }
        }
        catch{
            print("failed to update url")
        }
        
        
    }
    
    public func delete(personObject: NSManagedObject){
      
        persistentContainer.viewContext.delete(personObject)
        saveContext()
        
    }
    
    
    
}
extension Sendable{
    
    func send(){
        
    }
    
}
