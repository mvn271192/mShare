//
//  GroupTableViewCell.swift
//  mShare
//
//  Created by Manikandan V Nair on 05/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  func setData(group:Group)
    {
        groupNameLabel?.text = group.name
        discriptionLabel?.text = "Created by admin "
        notificationCount?.text = "14"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
