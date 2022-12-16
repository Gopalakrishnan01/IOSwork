//
//  AccountsViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 08/12/22.
//

import UIKit
import FirebaseAuth

protocol AccountsViewControllerDelegate:AnyObject{
    
    func logoutFromAccount()
    
}

protocol AccountsDisplayLogic: AnyObject{
    func updateAndLogOut()
}

class AccountsViewController: UIViewController {
    
    private var options = AccountsModel.options
    var delegate: AccountsViewControllerDelegate?
    var intractor: AccountsBusinessLogic!
    
    private var tableView: UITableView = {
        let tableView =  UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.config()
    }
    
  
    private func config(){
        
        //MARK: tableView
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        tableView.register(UINib(nibName: "AccountsTableViewCell", bundle: nil), forCellReuseIdentifier: AccountsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    deinit{
        print("accounts view controller deinited")
    }
    
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountsTableViewCell.identifier, for: indexPath) as? AccountsTableViewCell
        else{
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.optionLabel.text = options[indexPath.row]
            cell.descriptionLabel.textColor = UIColor(named: "lightGray")
            cell.descriptionLabel.font = .systemFont(ofSize: 15)
            cell.descriptionLabel.text = "Deleting your account will delete all your contacts and chats in Arattai"
        }
        else{
            cell.optionLabel.textColor = .red
            cell.optionLabel.text = options[indexPath.row]
            cell.descriptionLabel.text = ""
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if indexPath.row == 1{
            navigationController?.popViewController(animated: false)
            do{
                try Auth.auth().signOut()
                intractor.deleteChats()
            }
            catch{
                
            }
            
        }
        
        
        
    }
    
}

extension AccountsViewController: AccountsDisplayLogic{
    
    func setUp(){
        let intractor = AccountsIntractor()
        let presentor = AccountsPresentor()
        
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
        
    }
    
    func updateAndLogOut() {
        navigationController?.popViewController(animated: false)
        delegate?.logoutFromAccount()
    }
    
    
}
