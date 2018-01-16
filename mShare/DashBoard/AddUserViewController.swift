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
import SkyFloatingLabelTextField

protocol AddUserProtocol: NSObjectProtocol {
    
    func userAddedtoGroup(user: mUser)
}

class AddUserViewController: UIViewController {
    
    
    
    weak var delegate:AddUserProtocol?
    @IBOutlet weak var userSearchView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    private lazy var databaseRef: DatabaseReference = Database.database().reference()
    
    var selectedGroup:Group!
    var newUser:mUser!
    
    let common = Common()
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userSearchView.isHidden = true
        
        emailTextField.titleLabel.font = UIFont(name: Font, size: CGFloat(FontSize))
        emailTextField.placeholderFont = UIFont(name: Font, size: CGFloat(FontSize))
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
                        self.newUser = user
                        self.setUserView(forUser: user)
                        nvactivity.stopAnimating()
                    }
                    
                }
                
            })
        }
        
    }
    
    
    @IBAction func addUserButtonClick(_ sender: Any)
    {
        self.emailTextField.text = ""
        if (selectedGroup.members?.contains(newUser.uid))!
        {
            self.view.makeToast("User already added")
            
            return
        }
        let nvactivity = common.setActitvityIndicator(inView: self.view)
        nvactivity.startAnimating()
        
        let grpRef = databaseRef.child(GROUP).child(self.selectedGroup.gId).child("members")
        let userRef = databaseRef.child(USERS).child(newUser.uid).child(GROUP)
        
        grpRef.child(newUser.uid).setValue(true) { (error, databaseRef) in
            
            if let err = error
            {
                self.view.makeToast("Insertion fail")
                print(err)
                return
            }
            else
            {
                print(databaseRef.key)
                userRef.child(self.selectedGroup.gId).setValue(true, withCompletionBlock: { (error1, userDatabaseRref) in
                    
                    DispatchQueue.main.async {
                        nvactivity.stopAnimating()
                    }
                    if let err = error1
                    {
                        self.view.makeToast("Insertion fail")
                        print(err)
                        return
                    }
                    else
                    {
                        print(userDatabaseRref.key)
                        self.view.makeToast("User added")
                        if ((self.delegate) != nil)
                        {
                            self.delegate?.userAddedtoGroup(user: self.newUser)
                        }
                        self.userSearchView.isHidden = true
                        //self.navigationController?.popViewController(animated: true)
                    }
                })
                
            }
            
        }
       
    }
    
    
    // MARK: - Fuctions
    
    func setUserView(forUser user:mUser)
    {
        
        let nameLabel = userSearchView.viewWithTag(NameTag) as! UILabel
        let emailLabel = userSearchView.viewWithTag(EmailTag) as! UILabel
        let photoImageView = userSearchView.viewWithTag(PhotoTag) as! UIImageView
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        

        
        self.userSearchView.isHidden = false
        common.dropShadow(color: UIColor.black, view: self.userSearchView)
        
     
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
