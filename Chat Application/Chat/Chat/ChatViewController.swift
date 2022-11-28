//
//  ChatViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 03/11/22.
//

import UIKit


class ChatViewController: UIViewController{
    
  
  
    private var phoneNumber = ""
    private var userName = ""
    
    
    private let tableView:UITableView = {
        let table = UITableView()
//        table.isH idden = true
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
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.validateLoggedIn()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    
    func validateLoggedIn(){
        let loggedIn=UserDefaults.standard.bool(forKey: "logged_in")
        
        if !loggedIn{
            let loginVC=UINavigationController(rootViewController: LoginViewController())
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC,animated: false)
           
        }

//        UserDefaults.standard.setValue(false, forKey: "set_profileInfo")
        let ProfileInfo = UserDefaults.standard.bool(forKey: "set_profileInfo")
        if !ProfileInfo {
            let profileInfoVC=UINavigationController(rootViewController: ProfileInfoViewController())
            
            profileInfoVC.modalPresentationStyle = .fullScreen
            self.present(profileInfoVC,animated: false)
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
    
    @objc private func navigateToSearchContact(){
        
        let searchVC=UINavigationController(rootViewController: SearchViewController())
//        searchVC.completion = {
//            [weak self] result in
//            print(result)
//        }
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC,animated: false)
        
        
    }
    
    
}


extension ChatViewController : UITableViewDelegate , UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactChatTableViewCell", for: indexPath) as? ContactChatTableViewCell
        else
        {
            return UITableViewCell()
            
        }
       
        
        cell.profileImage.image = UIImage(systemName: "person")
        cell.name.text = "santhosh"
        cell.desc.text = "Hello"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nextVC=ConversationViewController()
        nextVC.title="santhosh"
        nextVC.navigationItem .largeTitleDisplayMode = .never
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
