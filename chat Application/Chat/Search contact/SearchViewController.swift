//
//  SearchViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import UIKit
import JGProgressHUD
import SDWebImage
import CoreData


protocol SearchViewControllerDisplayLogic:AnyObject{
    
    
    func updateFilteredContact(_ filteredContacts:[NSManagedObject]?)
    
}


class SearchViewController: UIViewController {
  
   
    public var completion:((NSManagedObject)->Void)!
    
    private var intractor: SearchBusinessLogic!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var phoneNumber:[String]?
    private var phoneNumbers=[String]()
    private var userDetails=[String:String]()
    private var profileImageUrl:[URL]?
    
    private var SearchContacts:[NSManagedObject]?
    private var contacts:[NSManagedObject]?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.contacts = PersonEntity.shared.fetchPersons()
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
        ContactSearchBar.searchResultsUpdater = self
        
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


extension SearchViewController:SearchViewControllerDisplayLogic{
    
    func updateFilteredContact(_ filteredContacts: [NSManagedObject]?) {
        self.SearchContacts = filteredContacts
        tableView.reloadData()
    }
        
    @objc func dismissViewController(){
        self.dismiss(animated: false)
    }
    
    
}



extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text{
            self.intractor.filterContacts(contacts,text: &text )
        }

    }

    
}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SearchContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
        
        else{
            return UITableViewCell()
        }
        
        if let data = SearchContacts?[indexPath.row],
           let url = URL(string: data.value(forKey: "url") as! String) ,
           let name = data.value(forKey: "name"){
            cell.nameLabel.text = name as? String
            cell.profileImage.sd_setImage(with: url)
        }
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contacts = SearchContacts
        ContactSearchBar.isActive = false
        if let target = self.contacts {
            let value = target[indexPath.row]
            self.dismiss(animated: false) {
                self.completion(value)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
   
}
