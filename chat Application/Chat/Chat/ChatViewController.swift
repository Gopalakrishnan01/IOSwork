//
//  ChatViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 03/11/22.
//

import UIKit
import SDWebImage
import FirebaseAuth
import CoreData


protocol ChatDisplayLogic:AnyObject{
    func updateChats(_ response:[NSManagedObject])
}

class ChatViewController: UIViewController,ChatDisplayLogic{
    
    
    
  
    public var intractor:ChatBusinessLogic!
    
    
    private var contactsDetails = [NSManagedObject]()
    private var chats = [NSManagedObject]()
    
    private let tableView:UITableView = {
        let table = UITableView()
        return table
    }()
    
    
    
    private let noConverstationLabel : UILabel = {
        let label = UILabel()
        label.text = "No conversation"
        label.textAlignment = .center
        label.textColor = UIColor(named: "gray")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.config()
        self.validateLoggedIn()
        self.setup()
        self.intractor.startListeningForChats()
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.intractor.getChats()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    func setup(){
        
        let intractor = ChatIntractor()
        let presentor = ChatPresentor()
        
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
        
    }
    
    func updateChats(_ response:[NSManagedObject]) {
        self.chats = response
        tableView.reloadData()
    }
    

    func validateLoggedIn(){
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC=UINavigationController(rootViewController: LoginViewController())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC,animated: false)
            }
            
        }
        
        
    }
    
    
    func config(){
        
        //MARK: Configure NavigationBar
        navigationController?.navigationBar.isTranslucent=false
        navigationItem.rightBarButtonItems=[
            UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(newBroadCast)),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(navigateToSearchContact))
        ]
        
        let leftbutton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        leftbutton.setTitle("Chats", for: .normal)
        leftbutton.titleLabel?.font=UIFont.boldSystemFont(ofSize: 35)
        leftbutton.setTitleColor(.label, for: .normal)
        leftbutton.contentHorizontalAlignment = .left
        let leftbarbtn = UIBarButtonItem(customView: leftbutton)
        navigationItem.leftBarButtonItem = leftbarbtn
        navigationController?.navigationBar.tintColor = .label
        
        //MARK: Chat Table
        self.view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ContactChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactChatTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: NoconversationLabel
        self.view.addSubview(noConverstationLabel)
    }
    

}


extension ChatViewController{
    
  
    
    @objc private func newBroadCast(){
        
    }
    
    func openConversation(_ model: NSManagedObject){
        guard let name = model.value(forKey: "name") as? String,
              let otherUserPhoneNumber = model.value(forKey: "otherUserPhoneNumber") as? String  ,
              let id = model.value(forKey: "id") as? String,
              let url = model.value(forKey: "imageUrl") as? String
        else{
            return
        }
        let nextVC=ConversationViewController(name: name, phoneNumber: otherUserPhoneNumber, conversationId: id,url: url)
        nextVC.title=name
        nextVC.isNewConversation=false
        nextVC.navigationItem .largeTitleDisplayMode = .never
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func navigateToSearchContact(){
        let nextVC = SearchViewController()
        let searchVC=UINavigationController(rootViewController: nextVC)
        nextVC.completion = {
            [weak self] userData in
            guard let strongSelf = self,
                  let phoneNumber = userData.value(forKey: "phoneNumber") as? String
            else{ return }
            
            for value in strongSelf.chats{
                if let number = value.value(forKey: "otherUserPhoneNumber") as? String , number == phoneNumber{
                    strongSelf.openConversation(value)
                    return
                }
                
            }
            
            strongSelf.createNewConversationViewController(model: userData)
        }
        
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC,animated: false)
        
        
    }
    
    func createNewConversationViewController(model:NSManagedObject){
       if  let name = model.value(forKey: "name") as? String,
           let number = model.value(forKey: "phoneNumber") as? String,
           let url = model.value(forKey: "url") as? String
           
        {
           let otherUserPhoneNumber = number.replacingOccurrences(of: " ", with:  "")
           let nextVC=ConversationViewController(name: name, phoneNumber: otherUserPhoneNumber,url: url)
           nextVC.title=name
           nextVC.isNewConversation=true
           nextVC.navigationItem .largeTitleDisplayMode = .never
           navigationController?.pushViewController(nextVC, animated: true)}
        
    }
}


extension ChatViewController : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  chats.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactChatTableViewCell", for: indexPath) as? ContactChatTableViewCell
        else
        {
            return UITableViewCell()
        }
        let model = chats[indexPath.row]
       
                
        cell.configure(with: model)
        if let url = model.value(forKey: "imageUrl") as? String,
            let phoneNumber = model.value(forKey: "otherUserPhoneNumber") as? String{
            self.intractor.downloadProfileImageUrl(fileName: "\(phoneNumber)_profile_picture.png") {
                path in
                if path != url{
                    self.intractor.updateProfileImageUrl(Path: path,model: model)
                    cell.userProfileImage.sd_setImage(with: URL(string: path))
                }
            }
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = chats[indexPath.row]
        openConversation(model)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    
}

