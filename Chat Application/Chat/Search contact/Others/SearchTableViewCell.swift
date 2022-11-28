//
//  SearchTableViewCell.swift
//  Chat
//
//  Created by zs-mac-6 on 23/11/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var profileImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
