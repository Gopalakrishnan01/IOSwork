//
//  ConversationViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 01/11/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView


protocol ConversationDisplayLogic:AnyObject{
    func updateAllMessagesForConversation(viewModel: [ConversationModel.Message])
    func updateMessageSent()
}

class ConversationViewController: MessagesViewController {
   
    
    
    public var intractor: ConversationBusinessLogic!
    private var name:String
    private var phoneNumber:String
    private var conversationId:String?
    private var url:String?
    
    private var messages=[ConversationModel.Message]()
    private var sender:ConversationModel.Sender? {
        guard let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String
        else{
            return nil
        }
        return ConversationModel.Sender(photoUrl: "",
               senderId: phoneNumber,
               displayName: "Me")
    }
    
    private var dateFormatter = ConversationModel.dateFormatter
    public var isNewConversation=true
    
    init(name:String,phoneNumber:String,conversationId:String? = "" ,url:String){
        self.name = name
        self.phoneNumber = phoneNumber
        self.url = url
        if let conversationId = conversationId{
            self.conversationId = conversationId
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.setup()
        self.config()
        self.setUpInputButton()
        self.intractor.listenForMessage(id:conversationId)
                
    }
    
    
    private func setup(){
        let intractor = ConversationIntractor()
        let presentor = ConversationPresentor()
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
        
    }
    
    private func config(){
        
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
        messageInputBar.inputTextView.becomeFirstResponder()
        messagesCollectionView.messagesDataSource=self
        messagesCollectionView.messagesLayoutDelegate=self
        messagesCollectionView.messagesDisplayDelegate=self
        messagesCollectionView.showsVerticalScrollIndicator = false
        messageInputBar.delegate = self
        
       
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
          }
        
        messageInputBar.sendButton.configure {
            $0.setSize(CGSize(width: 36 , height: 36), animated: false)
            $0.isEnabled = false
            $0.image = UIImage(systemName: "paperplane.fill")
            $0.title = ""
            $0.tintColor = UIColor(named: "appTint")
            $0.layer.cornerRadius = 16
                    }
    }
    
    func setUpInputButton(){
        
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = UIColor(named: "lightGray")
        button.tintColor = .white
        button.layer.cornerRadius = 17.5
        button.onTouchUpInside {
           [weak self] _ in
            self?.presentAttachmentViewController()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
        
        
    }
    
}

extension ConversationViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of:" ", with: "").isEmpty  ,
              let selfSender = sender,
              let id = conversationId
        else {return }
        guard let messageId = createMessageId() else { return }
        
        let message = ConversationModel.Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
      
        if isNewConversation{
            /// create new conversation
            intractor.sendMessage(with: message,to:name,with:phoneNumber)
            isNewConversation = false
            conversationId = "conversations_\(messageId)"
            
            
        }else{
           /// append message to existing conversation
            intractor.sendMessageToExistingChat(conversationId: id,otherUserPhoneNumber: phoneNumber,name: name, message: message)
        }
            
        inputBar.inputTextView.text = ""
        
    }
    
    private func createMessageId()->String?{
        // date , other user phone number, sender phone number
        let dateString = dateFormatter.string(from: Date())
        guard let senderPhoneNumber = UserDefaults.standard.value(forKey: "phoneNumber")

        else {
            return nil
        }
        let newIndentifer = "\(self.phoneNumber)\(senderPhoneNumber)_\(dateString)"
        return newIndentifer
    }
    
    
    
    
}
 
extension ConversationViewController: ConversationDisplayLogic{
    func updateMessageSent() {
        self.isNewConversation = false
    }
    
    func updateAllMessagesForConversation(viewModel: [ConversationModel.Message]) {
        DispatchQueue.main.async {
            self.messages = viewModel
            self.messagesCollectionView.reloadDataAndKeepOffset()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
    @objc func popToPreviousViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func phoneCallToContact(){
        
    }
    
    @objc func VideoCallToContact(){
        
    }
    
    func presentAttachmentViewController(){
        
    }
    
}

extension ConversationViewController : MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate {
    
    func currentSender() -> MessageKit.SenderType {
        if let selfSender = sender{
            return selfSender
        }
        
        return ConversationModel.Sender(photoUrl: "", senderId: "dummy ", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
     
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let unknownSender = message.sender
        guard let sender = sender ,
              let color = UIColor(named: "appTint")
        else{
            return .systemBackground
        }
        if unknownSender.senderId == sender.senderId{
            return color
        }
        else{
            return .systemBackground
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let unknownSender = message.sender
       
        guard let sender = sender
        else{
            return
        }
        if let path = url,unknownSender.senderId != sender.senderId{
            if indexPath.section == 0 {
                avatarView.isHidden = false
                avatarView.sd_setImage(with: URL(string: path))
            }
            else if messages[indexPath.section-1].sender.senderId == sender.senderId{
                avatarView.isHidden=false
                avatarView.sd_setImage(with: URL(string: path))
            }
            else{
                avatarView.isHidden = true
            }
        }
        
        
    }
    
    
}
