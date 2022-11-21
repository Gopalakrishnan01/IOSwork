//
//  CategoryCollectionViewCell.swift
//  News
//
//  Created by zs-mac-6 on 17/11/22.
//

import UIKit

class CategorySelectionCollectionViewCell: UICollectionViewCell {
    
    
    
    
    static let identifier="CategorySelectionCollectionViewCell"
    
    var categoryImageView:UIImageView = {
       
        let imageView=UIImageView(frame: .zero)
        imageView.layer.masksToBounds=true
        imageView.layer.cornerRadius=20
        return imageView
        
    }()
    
    var categoryTitleLabel:UILabel = {
        let label=UILabel(frame: .zero)
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .systemBackground
        self.config()
        
    }
    
    
    func config(){
        //MARK: category image
        contentView.addSubview(categoryImageView)
        categoryImageView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            categoryImageView.heightAnchor.constraint(equalToConstant: 170),
            categoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        
        //MARK: category title
        contentView.addSubview(categoryTitleLabel)
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([
            categoryTitleLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor,constant: 10),
            categoryTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
    }
    
    
    
    
    
    
    
}
