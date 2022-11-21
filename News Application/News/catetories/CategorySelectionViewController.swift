//
//  CategorySelectionViewController.swift
//  News
//
//  Created by zs-mac-6 on 18/11/22.
//

import UIKit

class CategorySelectionViewController: UIViewController {
    
    
    
    let categories=CategoryModel.FetchResponse.categories
    
    lazy var categoryCollectionView:UICollectionView = {
        let width=self.view.frame.width/2-20
        let height=200
        let layout=UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: width, height: 250)
        layout.minimumLineSpacing=5
        layout.minimumInteritemSpacing=5
        let collectionView=UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.isScrollEnabled=false
        return collectionView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="categories"
        self.view.backgroundColor = .systemBackground
        self.config()
       
    }
    
    
    func config(){
        
        
        //MARK: collection view
        self.view.addSubview(categoryCollectionView)
        
        categoryCollectionView.register(CategorySelectionCollectionViewCell.self, forCellWithReuseIdentifier: CategorySelectionCollectionViewCell.identifier)
        categoryCollectionView.delegate=self
        categoryCollectionView.dataSource=self
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints=false
        
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10),
            categoryCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10),
            categoryCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            categoryCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        ])
        
        
    }

   

}



extension CategorySelectionViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySelectionCollectionViewCell.identifier, for: indexPath) as? CategorySelectionCollectionViewCell else
        {
            return UICollectionViewCell()
            
        }
        let category=categories[indexPath.row]
        cell.categoryTitleLabel.text = category
        
        cell.categoryImageView.image = UIImage(named: category)
        return cell
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let nextVC=CategoriesViewController()
        nextVC.category=categories[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }
    
    


    
}
