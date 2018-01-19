//
//  PaidUserTableViewCell.swift
//  mShare
//
//  Created by Manikandan V Nair on 19/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PaidUserTableViewCell: UITableViewCell, UITextFieldDelegate{

    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUserData(user:mUser, isMultiple: Bool)
    {
        nameLabel?.text = user.name
        amountTextField.isHidden = !isMultiple
        amountTextField.delegate = self
        
        DispatchQueue.global(qos: .background).async {
            
            let photoURL = user.photoURL
            if let url = photoURL {
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    
                    if let imgData = data
                    {
                        let image = UIImage(data: imgData)
                        self.profilePicImageView?.image = image
                        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height/2
                        self.profilePicImageView.layer.masksToBounds = true
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let countdots = (textField.text?.components(separatedBy: ["."]).count)! - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
    
}
