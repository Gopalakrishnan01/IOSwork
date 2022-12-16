//
//  AccountsTableViewCell.swift
//  Chat
//
//  Created by zs-mac-6 on 08/12/22.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {
    
    
    static let identifier = "AccountsTableViewCell"
    
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
