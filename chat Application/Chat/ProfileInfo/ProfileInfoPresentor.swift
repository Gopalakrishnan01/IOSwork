//
//  ProfileInfoPresentor.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import Foundation

protocol ProfileInfoPresentationLogic:AnyObject{
    func validatedContact()
}

class ProfileInfoPresentor:ProfileInfoPresentationLogic{
    
    
    weak var viewController: ProfileInfoDisplayLogic!
    
    func validatedContact() {
        viewController.updateValidatedContactProccessFinished()
    }
    
    
}
