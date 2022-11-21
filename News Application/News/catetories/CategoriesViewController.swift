//
//  CategoriesViewController.swift
//  News
//
//  Created by zs-mac-6 on 14/11/22.
//

import UIKit


protocol CategoryDisplayLogic:AnyObject{
    
    func update(viewModel: CategoryModel.ViewModel!)
}

class CategoriesViewController: UIViewController {
    
    
    
    
    
    var intractor:CategoryBusinessLogic!
    var viewModel:CategoryModel.ViewModel!
    var category:String!
   
    var tableNewsFeed:UITableView = {
        let tableView=UITableView(frame: .zero)
        tableView.backgroundColor = .systemBackground
         return tableView
        
    }()
    
    
    override func loadView() {
        super.loadView()
        self.config()
        self.setUp()
        self.fetchNews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=category
        self.view.backgroundColor = .systemBackground
        

        
        
    }
    
    func config(){
        
        //MARK: tableView layout
        tableNewsFeed.estimatedRowHeight=100
        tableNewsFeed.rowHeight = UITableView.automaticDimension
        tableNewsFeed.delegate = self
        tableNewsFeed.dataSource = self
        tableNewsFeed.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        self.view.addSubview(tableNewsFeed)
        tableNewsFeed.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableNewsFeed.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableNewsFeed.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableNewsFeed.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableNewsFeed.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        ])
       
        
    }
    
    
    func setUp(){
        
     let intractor=CategoryIntractor()
        let presentor=CategoryPresentor()
        intractor.presentor=presentor
        presentor.viewController=self
        self.intractor=intractor
        
    }
    
    
    func fetchNews(){
        intractor.category=self.category
        intractor.categoryTopNews()
        
    }
    
}


extension CategoriesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell=tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else{
                return UITableViewCell()
            }
        let fetchedResource=viewModel.articles[indexPath.row]
        cell.newsTitle.text=fetchedResource.description
            
        intractor.fetchImage(with: fetchedResource.urlToImage, completion: {
                data,url in
                if url  == url{
                    cell.newsImageView.image = UIImage(data: data)
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

extension CategoriesViewController:CategoryDisplayLogic{
    
    func update(viewModel: CategoryModel.ViewModel!) {
        self.viewModel=viewModel
        tableNewsFeed.reloadData()
    }
    
}


