//
//  ContactChatTableViewCell.swift
//  Chat
//
//  Created by zs-mac-6 on 24/11/22.
//

import UIKit
import SDWebImage
import CoreData

class ContactChatTableViewCell: UITableViewCell {
    
    
   
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configure(with model: NSManagedObject){
        
        guard let name = model.value(forKey: "name") as? String,
              let latestMessageText = model.value(forKey: "latestMessageText") as? String,
              let url = model.value(forKey: "imageUrl") as? String
        else{
            return
        }
        self.userNameLabel.text = name
        self.userMessageLabel.text = latestMessageText
        self.userProfileImage.sd_setImage(with: URL(string: url))
        
       
        
    }
    
}
