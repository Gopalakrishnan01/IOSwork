//
//  ProfileInfoViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 22/11/22.
//

import UIKit
import JGProgressHUD
import SDWebImage

protocol ProfileInfoDisplayLogic:AnyObject{
    func updateValidatedContactProccessFinished()
}

class ProfileInfoViewController: UIViewController, UINavigationControllerDelegate {
    
   
    
    private var intractor: ProfileInfoBusinessLogic!
    private var isImageSelected = false
    private var spinner = JGProgressHUD(style: .light)
    
    var profileInfoLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Profile info"
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var descriptionLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Please provide your name and an optional profile photo"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines=0
        return label
    }()
    
    var profileImageButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = UIColor(named: "appTint")
        button.contentMode = .center
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(didTapProfileImageButton), for: .touchUpInside)
        button.layer.borderColor = UIColor(named: "appTint")?.cgColor
        return button
    }()
    
    var nextButton:UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(named: "appTint")
        button.layer.masksToBounds=true
        button.layer.cornerRadius=20
        button.addTarget(self, action: #selector(loggIn), for: .touchUpInside)
        return button
    }()
    
    var nameTextField:UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Enter your name"
        return textField
    }()
    
    var lineView:UIView = {
        let view=UIView(frame: .zero)
        view.backgroundColor = UIColor(named: "gray")
        return view
    }()
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.config()
        self.setUp()
        self.intractor.fetchAllContacts()
    }
    
    func setUp(){
        let intractor = ProfileInfoIntractor()
        let presentor = ProfileInfoPresentor()
        
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
    }
    
    func config(){
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissTheKeyboard))
        self.view.addGestureRecognizer(tapGuesture)
        //MARK: ProfileInfo Label
        
        self.view.addSubview(profileInfoLabel)
        profileInfoLabel.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            profileInfoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            profileInfoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            profileInfoLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100),
            profileInfoLabel.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        //MARK: Description Label
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: profileInfoLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: profileInfoLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor,constant: 10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        //MARK: ProfileImage picker
        
        self.view.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 20),
            profileImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: 100),
            profileImageButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        profileImageButton.layer.masksToBounds=true
        profileImageButton.layer.cornerRadius = 50
        profileImageButton.layer.borderWidth = 3
        
        //MARK: Name TextField
        
        self.view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            nameTextField.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor,constant: 50),
            nameTextField.widthAnchor.constraint(equalToConstant: 40)
            
            
        ])
        
        //MARK: line view
        
        self.view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 4),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        //MARK: Next button
        
        self.view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        
    }
    
    
    @objc private func didTapProfileImageButton(){
        self.presentPhotoActionSheet()
    }
    
    @objc func dismissTheKeyboard(){
        nameTextField.resignFirstResponder()
    }
}

extension ProfileInfoViewController:UIImagePickerControllerDelegate{
    
    
    @objc private func loggIn(){
        
        
        if nameTextField.text != "" {
           
            let profileImage = isImageSelected ? self.profileImageButton.imageView?.image?.pngData() : UIImage(systemName: "person.fill")?.pngData()
            
            spinner.show(in: self.view)
            intractor.createUser(userName:nameTextField.text,profileImage)
            
            if let workDone = UserDefaults.standard.value(forKey: "set_profileInfo") as? Bool, workDone{
                spinner.dismiss(animated: false)
                self.view.window?.rootViewController?.dismiss(animated: false)
            }
        }
        
    }
    
    
    func presentPhotoActionSheet(){
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "how would you select profile picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel,handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default,handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default,handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet,animated: true)
        
        
        
    }
    
    private func presentCamera(){
        let vc=UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    private func presentPhotoPicker(){
        let vc=UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true,completion: nil)
        isImageSelected=true
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage]
        profileImageButton.layer.borderWidth=0
        self.profileImageButton.setImage(selectedImage as? UIImage , for: .normal)
        
    }
    
    
    
}

extension ProfileInfoViewController: ProfileInfoDisplayLogic{
    
    
    func updateValidatedContactProccessFinished(){
        UserDefaults.standard.set(true, forKey: "set_profileInfo")
    }
    
    
}

