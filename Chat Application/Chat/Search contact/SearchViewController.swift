//
//  SearchViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import UIKit
import JGProgressHUD
import SDWebImage
import Contacts

protocol SearchViewControllerDisplayLogic:AnyObject{
    
    func update(viewModel:SearchModel.ViewModel.another)
    
}


class SearchViewController: UIViewController,SearchViewControllerDisplayLogic {
   
    public var completion:(([String:String])->Void)!
    
    private var intractor: SearchBusinessLogic!
    
    private let spinner = JGProgressHUD(style: .light)
    
    private var phoneNumber:[String]?
    private var phoneNumbers=[String]()
    private var userDetails=[String:String]()
    private var profileImageUrl:[URL]?
    
    private var SearchContacts:SearchModel.ViewModel.another?
    
    private var ContactSearchBar: UISearchController = {
        let searchBar=UISearchController(searchResultsController: nil)
        searchBar.becomeFirstResponder()
        searchBar.searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.config()
        self.setUp()
    }
    
    func config(){
        
        //MARK: Search Bar
        let button = UIButton()
        button.setImage(UIImage(systemName:"chevron.left"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.searchController = ContactSearchBar
        ContactSearchBar.searchBar.searchTextField.delegate = self
        ContactSearchBar.searchBar.delegate = self
        
        //MARK: Add Guesture
        
        let swipeGuestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController))
        
        swipeGuestureRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeGuestureRecognizer)
        
        //MARK: Table view
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10)
        
        
        ])
        
    }
    
    
    func setUp(){
        
        let intractor = SearchIntractor()
        let presentor = SearchPresentor()
        intractor.presentor = presentor
        presentor.viewController = self
        self.intractor = intractor
        
    }

    

}


extension SearchViewController {
    
    @objc func dismissViewController(){
        self.dismiss(animated: false)
    }
    
    func searchUsers(_ phoneNumbers: [String]){
        intractor.fetchUsers(phoneNumbers: phoneNumbers)
    }
    
    func update(viewModel: SearchModel.ViewModel.another) {
        SearchContacts = viewModel
        
        for phoneNumber in phoneNumbers{
            
                let fileName = "\(phoneNumber)_profile_picture.png"
                StorageManager.shared.downloadProfilePictureUrl(fileName:fileName ){
                    
                    result in
                    
                    switch(result){
                    case .success( let imageUrl):
                        if let url = URL(string: imageUrl){
                            self.profileImageUrl?.append(url)
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                }
                
            
        }
        self.tableView.reloadData()
        self.spinner.dismiss(animated: true)
        
    }
    
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty
        else{
           return
        }
        
        let store = CNContactStore()
        
        let keys = [CNContactGivenNameKey,CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        let predicate = CNContact.predicateForContacts(matchingName: text)
        
        do{
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
                for value in contacts{
                    let name = value.givenName
                    let phonenumber = value.phoneNumbers.compactMap({ number in
                        return number.value.stringValue
                    })
                    self.userDetails.updateValue(name, forKey: phonenumber[0])
                    self.phoneNumbers.append(phonenumber[0])
                    
                }
            
            
            
            
        }
        catch{
            print(error)
        }
       
        self.searchUsers(phoneNumbers)
        
        
       
//        spinner.show(in: self.view)
        
    }
    
    
}

extension SearchViewController: UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SearchContacts?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
        
        else{
            return UITableViewCell()
        }
        cell.nameLabel.text = userDetails[phoneNumbers[indexPath.row]]
        
        
        
        cell.profileImage.sd_setImage(with: profileImageUrl?[indexPath.row])
        
        
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let target =  SearchContacts?.data[indexPath.row] {
            self.dismiss(animated: true) {
                [weak self] in
                self?.completion(target)
            }
        }
        
       
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    

    
    
}
