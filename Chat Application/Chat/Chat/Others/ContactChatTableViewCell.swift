//
//  ContactChatTableViewCell.swift
//  Chat
//
//  Created by zs-mac-6 on 24/11/22.
//

import UIKit

class ContactChatTableViewCell: UITableViewCell {
    
    
   
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
