//
//  SearchPresentor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation
import CoreData

protocol SearchPresentationLogic:AnyObject{

    func filtredContacts(_ result :[NSManagedObject]?)
    
}

class SearchPresentor: SearchPresentationLogic{
    
    
    weak var viewController: SearchViewControllerDisplayLogic!
   
    func filtredContacts(_ result:[NSManagedObject]?){
        self.viewController.updateFilteredContact(result)
    }
   
}
