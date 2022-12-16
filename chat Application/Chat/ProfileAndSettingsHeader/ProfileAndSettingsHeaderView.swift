//
//  ProfileAndSettingsHeaderView.swift
//  Chat
//
//  Created by zs-mac-6 on 25/11/22.
//

import UIKit
import SDWebImage

protocol ProfileAndSettingsHeaderDisplayLogic:AnyObject {
    
    
    
}

class ProfileAndSettingsHeaderView: UIView,ProfileAndSettingsHeaderDisplayLogic {
    
    private var userName:String!
    private var phoneNumber:String!
    private var fileName:String!
   
    
    private var intractor : ProfileAndSettingsHeaderBussinessLogic!
    
    lazy private var profileImage:UIImageView = {
        let imageView =  UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.layer.masksToBounds =  true
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label=UILabel()
        label.backgroundColor = .systemBackground
        label.textColor = .label
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userName = UserDefaults.standard.value(forKey: "userName") as? String
        if let number = UserDefaults.standard.value(forKey: "phoneNumber") as? String {
            phoneNumber = number
        }
        fileName = DatabaseModel.UserInfo(name: userName, phoneNumber: phoneNumber).profilePictureFileName as String
        
        print(fileName)
        self.config()
        self.setUp()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
    private func config(){
        
        //MARK: profile ImageView
        
        self.addSubview(profileImage)
        StorageManager.shared.downloadProfilePictureUrl(fileName: fileName, completion: { result in
            switch (result){
            case .success(let profileImageUrl):
                self.profileImage.sd_setImage(with: URL(string: profileImageUrl))
            case .failure(_):
                self.profileImage.image = UIImage(systemName: "person.fill")

            }
        })

        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(systemName:"person")
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        ])
        
        //MARK: UserName Label
        self.addSubview(userNameLabel)
        userNameLabel.text = userName
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor,constant: 10),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        
        ])
        
        
    }
    
    func setUp(){
        
        let intractor = ProfileAndSettingsHeaderIntractor()
        let presentor = ProfileAndSettingsHeaderPresentor()
        self.intractor = intractor
        intractor.presentor = presentor
        presentor.view = self
       
    }
    
    
    
    
    
}

