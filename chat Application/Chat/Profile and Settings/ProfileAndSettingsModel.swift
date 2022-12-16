//
//  ProfileAndSettingsModel.swift
//  Chat
//
//  Created by zs-mac-6 on 25/11/22.
//

import Foundation

struct ProfileAndSettingsModel{
    
    
    static let options = [["Mentions","Starred messages","Contacts","Linked Devices"],["Accounts","Chats","Notifications and sounds ","Security and Privacy", "Data and Storage"],["Siri Shortcuts"],["About Us","Feedback","Invite Friends"]]
    
    static let viewControllers = [[MentionsViewController(),StarredMessagesViewController(),ContactsViewController(),LinkedDevicesViewController()],[AccountsViewController(),AccountsViewController(),AccountsViewController(),AccountsViewController(), AccountsViewController()],[AccountsViewController()],[AccountsViewController(),AccountsViewController(),AccountsViewController()]]
    
    
    struct FetchResponse{
        
        
        
    }
    
    
}
