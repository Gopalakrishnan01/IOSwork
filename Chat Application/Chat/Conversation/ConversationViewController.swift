//
//  ConversationViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 01/11/22.
//

import UIKit
import MessageKit

class ConversationViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let selfSender = Sender(photo: "",
                                    senderId: "1",
                                    displayName: "santhosh")
    
    
    
    
    private let FriendSender = Sender(photo: "", senderId: "2", displayName: "Nature")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.config()
        
        
        
    }
    
    
    func config(){
        
        //MARK: configure NavigationBar
         
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
      

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popToPreviousViewController))
        
        navigationItem.rightBarButtonItems=[
           
            UIBarButtonItem(image: UIImage(systemName: "phone"), style: .done, target: self, action: #selector(phoneCallToContact)),
            UIBarButtonItem(image: UIImage(systemName: "video"), style: .done, target: self, action: #selector(VideoCallToContact))
        ]
        
        //MARK: Editting messageColectionView
        let backgroundView =  UIImageView(image: UIImage(named: "background"))
        backgroundView.alpha = 0.2
                messagesCollectionView.backgroundView = backgroundView
        messagesCollectionView.messagesDataSource=self
        messagesCollectionView.messagesLayoutDelegate=self
        messagesCollectionView.messagesDisplayDelegate=self
        
        
        messages.append(Message(sender: selfSender,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text("hello  ")))
        
        messages.append(Message(sender: selfSender,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text(" I am santhosh ")))
        messages.append(Message(sender: FriendSender, messageId: "2", sentDate: Date(), kind: .text("hi")))
        
        messages.append(Message(sender: FriendSender, messageId: "2", sentDate: Date(), kind: .text("I am bhawath")))
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            
          }
        
        
    }
    
      
    
}
 
extension ConversationViewController{
    
    
    @objc func popToPreviousViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func phoneCallToContact(){
        
    }
    
    @objc func VideoCallToContact(){
        
    }
    
}

extension ConversationViewController : MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate {
    
    func currentSender() -> MessageKit.SenderType {
        return self.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
     
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(named: "appTint")!
    }
    
    
}
