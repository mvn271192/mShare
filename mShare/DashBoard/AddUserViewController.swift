//
//  AddUserViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 09/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Toast_Swift

class AddUserViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var userSearchView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    private lazy var databaseRef: DatabaseReference = Database.database().reference()
    
    let common = Common()
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userSearchView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - Action
    
    @IBAction func searchButtonClick(_ sender: Any)
    {
        emailTextField.resignFirstResponder()
        
        let nvactivity = common.setActitvityIndicator(inView: self.view)
        nvactivity.startAnimating()
        
        if  let emailText = emailTextField.text , emailText.count > 0
        {
            
            databaseRef.child(USERS).queryOrdered(byChild: "email").queryEqual(toValue: emailText).observe(.value, with: { (snapshot) in
                
                if !(snapshot.childrenCount > 0)
                {
                    nvactivity.stopAnimating()
                    self.view.makeToast("User not found")
                }
                
                for item in snapshot.children
                {
                    let snap = item as! DataSnapshot
                    let dic = snap.value as! Dictionary<String,AnyObject>
                    if let name = dic["name"] as! String!
                    {
                       
                        let email = dic["email"] as! String!
                        let photoURL = dic["photoURL"] as? String ?? ""
                        let user = mUser(name: name, email: email!, photoURL: photoURL, uid: snap.key)
                        self.setUserView(forUser: user)
                        nvactivity.stopAnimating()
                    }
                    
                }
                
            })
        }
        
    }
    
    
    @IBAction func addUserButtonClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Fuctions
    
    func setUserView(forUser user:mUser)
    {
        let nameLabel = userSearchView.viewWithTag(NameTag) as! UILabel
        let emailLabel = userSearchView.viewWithTag(EmailTag) as! UILabel
        let photoImageView = userSearchView.viewWithTag(PhotoTag) as! UIImageView
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        
        userSearchView.isHidden = false
        
        let nvIndicator = common.setActitvityIndicator(inView: photoImageView)
        nvIndicator.startAnimating()
        
        let photoURL = user.photoURL
        if let url = photoURL {
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: url)
            
            DispatchQueue.main.async {
                nvIndicator.stopAnimating()
                if let imgData = data
                {
                    let image = UIImage(data: imgData)
                    photoImageView.image = image
                    photoImageView.layer.cornerRadius = photoImageView.frame.size.height/2
                    photoImageView.layer.masksToBounds = true
                }
            }
            }
        }
        
        
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
