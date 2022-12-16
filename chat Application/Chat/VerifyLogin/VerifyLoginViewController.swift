//
//  VerifyLoginViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 03/11/22.
//

import UIKit
import JGProgressHUD

protocol VerifyLoginDisplayLogic:AnyObject{
   
}


class VerifyLoginViewController: UIViewController{
    
    var phoneNumber:String = ""
    
    var intractor: VerifyLoginBusinessLogic!
    
    
    private var spinner = JGProgressHUD()
    
    private var instructionLabel:UILabel = {
        let label=UILabel()
        label.text="Verify your mobile number"
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private var descriptionLabel:UILabel = {
        let label=UILabel()
        label.numberOfLines=0
        label.textAlignment = .center
        label.textColor = UIColor(named: "gray")
        return label
    }()
    
    
    private  var  verifySms:UITextField={
        let field=UITextField()
        field.placeholder = "OTP"
        field.keyboardType = .numbersAndPunctuation
        field.returnKeyType = .continue
        return field
    }()
    private var lineView:UIView = {
        let view=UIView()
        view.backgroundColor = UIColor(named: "appTint")
        return view
    }()
    
    
    
    private lazy var verifyButton:UIButton={
        let button = UIButton()
        button.setTitle("Verify", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .tintColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.config()
        self.setUp()
        
    }
    
    func config(){
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector (dismissViewController))
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissTheKeyboard))
        self.view.addGestureRecognizer(tapGuesture)
        
        //MARK: Instruction label
        self.view.addSubview(instructionLabel)
        instructionLabel.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            instructionLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100),
            instructionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //MARK: Description label
        self.view.addSubview(descriptionLabel)
        descriptionLabel.text="Enter the verification code you \n received on your mobile \n \(phoneNumber)"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor,constant: 5),
            
        ])
        
        
        
        //MARK: verifySms
        self.view.addSubview(verifySms)
        verifySms.delegate=self
        verifySms.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            verifySms.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            verifySms.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            verifySms.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 40),
            verifySms.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        
        //MARK: verifyButton
        self.view.addSubview(verifyButton)
        verifyButton.addTarget(self, action: #selector(verify), for: .touchUpInside)
        verifyButton.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([
            verifyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            verifyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            verifyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -40),
            verifyButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
        
        
        //MARK: Line view
        self.view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: verifySms.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: verifySms.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: verifySms.bottomAnchor,constant: 4),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    
    func setUp(){
        let intractor = VerifyLoginIntractor()
        let presentor = VerifyLoginPresentor()
        
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
    }
    
    
    
    
    
}


extension VerifyLoginViewController{
    
    @objc func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc func dismissTheKeyboard(){
        verifySms.resignFirstResponder()
    }
    
    @objc func verify(){
        verifySms.resignFirstResponder()
        
        if let code=verifySms.text ,!code.isEmpty{
            AuthManager.shared.verifyCode(smsCode: code){
                success in
                guard success else{
                    self.verifySms.text = ""
                    self.verifySms.placeholder = "Incorrect Password"
                    return
                }
                
                let profileInfoVC=UINavigationController(rootViewController: ProfileInfoViewController())
                profileInfoVC.modalPresentationStyle = .fullScreen
                self.present(profileInfoVC,animated: false)
                

                
            }
        }
    }
    
    
}


extension VerifyLoginViewController: VerifyLoginDisplayLogic{
  
    
    
}

extension VerifyLoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.verify()
        return true
    }
    
    
}
