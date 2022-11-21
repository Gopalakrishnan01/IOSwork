//
//  CategoryCollectionViewCell.swift
//  News
//
//  Created by zs-mac-6 on 14/11/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier="CategoryTableViewCell"
    
    
    var newsImageView:UIImageView = {
        let imageView=UIImageView(frame: .zero)
        imageView.layer.masksToBounds=true
        imageView.layer.cornerRadius=10
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    var newsTitle:UILabel = {
        let label=UILabel(frame: .zero)
        label.text=""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines=0
        return label
    }()
    
    override func layoutSubviews() {
        contentView.backgroundColor = .systemBackground
        self.config()
    }
    
    func config(){
        
        //MARK: newsImageView
        contentView.addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints=false
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width-40
        NSLayoutConstraint.activate([
        
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            newsImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            newsImageView.heightAnchor.constraint(equalToConstant: 200)
            
        
        ])
        
        
        //MARK: newsTitle

        contentView.addSubview(newsTitle)
        newsTitle.translatesAutoresizingMaskIntoConstraints=false

        NSLayoutConstraint.activate([
            newsTitle.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            newsTitle.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            newsTitle.topAnchor.constraint(equalTo: newsImageView.bottomAnchor,constant: 10),
            newsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:-15),
        ])
    
    }
    
    
    
}
