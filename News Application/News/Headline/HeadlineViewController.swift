//*
//  ViewController.swift
//  News

//  Created by zs-mac-6 on 07/11/22.
//

import UIKit

protocol HeadlineDisplayLogic:AnyObject{
    
    func update(viewModel: HeadlineModel.ViewModel)
    
}

class HeadlineViewController: UIViewController{
    
    private var intractor:HeadlineBusinessLogic!
    private var viewModel:HeadlineModel.ViewModel!
    var countrySelected:String?
    
    private let search=UISearchController(searchResultsController: nil)
    
    let countriesNamesAndCode=HeadlineModel.FetchResponse.countriesNamesAndCode
    
    let countryButton:UIButton = {
        
        let button=UIButton()
        button.setTitle("India", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.showsMenuAsPrimaryAction=true
        return button
    }()
    
    lazy var changeTitle = {
        (action:UIAction) in
        self.countrySelected=self.countriesNamesAndCode[action.title]
        self.countryButton.setTitle(action.title, for: .normal)
        self.fetchTopHeadlines()
    }
    
    @IBOutlet weak var headlineTable:UITableView!
    override func loadView() {
        super.loadView()
        self.setUp()
        self.fetchTopHeadlines()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
    }
    
    func setUp(){
        let intractor=HeadlineIntractor()
        let presentor=HeadlinePresentor()
        intractor.presentor=presentor
        presentor.viewController=self
        self.intractor=intractor
        
        headlineTable.register(UINib(nibName: "HeadlineTableViewCell", bundle: nil), forCellReuseIdentifier:
                                "HeadlineTableViewCell")
        headlineTable.estimatedRowHeight=100
        headlineTable.rowHeight = UITableView.automaticDimension
        headlineTable.delegate=self
        headlineTable.dataSource=self
        countryButton.menu=UIMenu(children: self.updateCountries())
        search.searchBar.delegate=self
        
    }
    func configNavigationBar(){
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem=UIBarButtonItem(customView: countryButton)
        navigationItem.searchController=search
        navigationController?.navigationBar.isTranslucent=false
    }
    
   
    func fetchTopHeadlines(){
        intractor.country=countrySelected ?? "in"
        intractor.getCategoryRelated()
    }
    func updateCountries()->[UIAction]{
        var countriesMenu=[UIAction]()
        
        for country in countriesNamesAndCode {
            countriesMenu.append(UIAction(title: country.0, handler: changeTitle))
        }
        countriesMenu.sort { a, b in
            return a.title < b.title
        }
        return countriesMenu
        
    }
}

extension HeadlineViewController: HeadlineDisplayLogic{
    func update(viewModel: HeadlineModel.ViewModel) {
        self.viewModel=viewModel
        headlineTable.reloadData()
    }
   
}

extension HeadlineViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeadlineTableViewCell",for: indexPath)as? HeadlineTableViewCell
        else{
            return UITableViewCell()
            
        }
        let this = viewModel.articles[indexPath.row]
        let imageUrl = this.urlToImage
        cell.newsImage.image = nil
        cell.title.text = this.title!
        if let description=viewModel.articles[indexPath.row].description{
            cell.desc.text=description
            
        }
        intractor.fetchImage(with: imageUrl, completion: {
            data,imgURL in
            if imageUrl  == imgURL{
                cell.newsImage.image = UIImage(data: data)
            }
            
        }) { error in
            print(error as Any)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController=NEWSViewController()
        if let link=viewModel.articles[indexPath.row].url{
            nextViewController.link=link
        }
        self.navigationController?.pushViewController(nextViewController, animated: false)
    }
}
extension HeadlineViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text=searchBar.text, !text.isEmpty else{return}
        intractor.search(text)
    }
}
