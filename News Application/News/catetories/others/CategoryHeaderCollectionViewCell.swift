//
//  CategoryHeaderCollectionViewCell.swift
//  News
//
//  Created by zs-mac-6 on 15/11/22.
//

import UIKit

class CategoryHeaderCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier="CategoryHeaderCollectionViewCell"
    
    
    var headerTitle:UILabel = {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.numberOfLines=0
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(headerTitle)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
