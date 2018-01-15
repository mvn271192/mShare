//
//  UserListTableViewCell.swift
//  mShare
//
//  Created by Manikandan V Nair on 15/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserData(user:mUser)
    {
        nameLabel?.text = user.name
        DispatchQueue.global(qos: .background).async {
            
            let photoURL = user.photoURL
            if let url = photoURL {
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    
                    if let imgData = data
                    {
                        let image = UIImage(data: imgData)
                        self.userProfilePic?.image = image
                        self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.size.height/2
                        self.userProfilePic.layer.masksToBounds = true
                    }
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
