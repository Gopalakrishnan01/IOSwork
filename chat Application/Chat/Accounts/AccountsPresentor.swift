//
//  AccountsPresentor.swift
//  Chat
//
//  Created by zs-mac-6 on 08/12/22.
//

import Foundation

protocol AccountsPresentationLogic:AnyObject{
    func updateAndLogOut()
}

class AccountsPresentor:AccountsPresentationLogic{
    
    
    weak var viewController:AccountsDisplayLogic!
    
    func updateAndLogOut() {
        viewController.updateAndLogOut()
    }
    
    
    
}
