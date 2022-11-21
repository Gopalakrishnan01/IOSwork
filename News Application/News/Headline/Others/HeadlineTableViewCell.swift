//
//  HeadlineTableViewCell.swift
//  News
//
//  Created by zs-mac-6 on 07/11/22.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title:UILabel!
    
    @IBOutlet weak var desc:UILabel!
    
    @IBOutlet weak var newsImage:UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
