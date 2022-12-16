//
//  ProfileAndSettingsTableViewCell.swift
//  Chat
//
//  Created by zs-mac-6 on 25/11/22.
//

import UIKit

class ProfileAndSettingsTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileAndSettingsTableViewCell"
    
    @IBOutlet weak var settingsImage: UIImageView!
    
    @IBOutlet weak var settingsName: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(named: "grayAndWhite")
    }
    
    
   
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
