//
//  LoginViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 01/11/22.
//

import UIKit
protocol LoginDisplayLogic:AnyObject{
    
}

class LoginViewController: UIViewController,LoginDisplayLogic {
    
    
    var intractor:LoginBusinessLogic!
    
    let countriesCode = LoginModel.countryCode.codes
    private var countryCode = "+91"
    
    var instructionLabel:UILabel = {
        let label=UILabel()
        label.text="Enter your mobile number"
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    var descriptionLabel:UILabel = {
        let label=UILabel()
        label.text="We will send a code to this \n mobile number for verification"
        label.numberOfLines=0
        label.textAlignment = .center
        label.textColor = UIColor(named: "gray")
        return label
    }()
    
    var countryCodeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.contentMode = .center
        button.tintColor = .label
        button.setTitle("+91", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
        
    }()
    
    lazy var changeTitle = {
        (action:UIAction) in
        self.countryCodeButton.setTitle(self.countriesCode[action.title], for: .normal)
        self.countryCode = self.countriesCode[action.title] ?? "+91"
    }
    
    
    var phoneNumberTextField:UITextField = {
        let field=UITextField()
        field.keyboardType = .numbersAndPunctuation
        field.returnKeyType = .continue
        return field
    }()
    
    var lineView:UIView = {
        let view=UIView()
        view.backgroundColor = UIColor(named: "appTint")
        return view
    }()
        override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.config()
        self.setup()
        
    }
    
    func config(){
        
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
        descriptionLabel.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor,constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //MARK: Country code Button
        self.view.addSubview(countryCodeButton)
        countryCodeButton.translatesAutoresizingMaskIntoConstraints = false
        countryCodeButton.menu = UIMenu(children: self.updateCountryCode())
        NSLayoutConstraint.activate([
            countryCodeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            countryCodeButton.widthAnchor.constraint(equalToConstant:  70),
            countryCodeButton.topAnchor.constraint(equalTo:  descriptionLabel.bottomAnchor,constant: 40),
            countryCodeButton.heightAnchor.constraint(equalToConstant:  50)
        ])
        
        

        
        //MARK: Phone Number TextField
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.delegate=self
        
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            phoneNumberTextField.leadingAnchor.constraint(equalTo: self.countryCodeButton.trailingAnchor,constant: 10),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20),
            phoneNumberTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 40),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        //MARK: Line view
        self.view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: countryCodeButton.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: phoneNumberTextField.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor,constant: 4),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        
    }
    
    func setup(){
        
        let intractor = LoginIntractor()
        let presentor = LogicPresentor()
        
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
        
    }
    
    
    func updateCountryCode() -> [UIAction]{
        var countriesCodeMenu=[UIAction]()
        for country in countriesCode {
            countriesCodeMenu.append(UIAction(title:
                                                "\(country.0)", handler: changeTitle))
        }
        countriesCodeMenu.sort { a, b in
            return a.title < b.title
        }
        return countriesCodeMenu
       
    }
    
    @objc func dismissTheKeyboard(){
        phoneNumberTextField.resignFirstResponder()
    }
    
   

}

extension LoginViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumberTextField.resignFirstResponder()
        if var text=phoneNumberTextField.text ,!text.isEmpty{
            text=text.trimmingCharacters(in: .whitespaces)
            let phoneNumber="\(self.countryCode)\(text)"
            UserDefaults.standard.setValue(phoneNumber as String, forKey: "phoneNumber")
            AuthManager.shared.startAuth(phoneNumber: phoneNumber){
                [weak self] success in
                
                guard success else{return}
                DispatchQueue.main.async {
                    let verifyVC=VerifyLoginViewController()
                    verifyVC.phoneNumber=phoneNumber
                    verifyVC.modalPresentationStyle = .fullScreen
                    self?.present(verifyVC,animated: false)
                }
            }
        }
        return true
    }
    
    
}
 
