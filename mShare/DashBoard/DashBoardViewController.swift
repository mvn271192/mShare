//
//  DashBoardViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 03/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase


class DashBoardViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var eMailLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var user:User!
    {
        didSet
        {
            userNameLabel?.text = user.displayName
            eMailLabel?.text = user.email
            let photoURL = user?.photoURL
            let data = try? Data(contentsOf: photoURL!)
            if let imgData = data
            {
                let image = UIImage(data: imgData)
              //  profilePic?.image = image
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
