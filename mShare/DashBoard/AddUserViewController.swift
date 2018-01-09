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

class AddUserViewController: UIViewController {

    @IBOutlet weak var userSearchView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    private lazy var databaseRef: DatabaseReference = Database.database().reference()
    
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
       if  let emailText = emailTextField.text , emailText.count > 0
       {
        
        databaseRef.child(USERS).queryOrdered(byChild: "email").queryEqual(toValue: emailText).observe(.value, with: { (snapshot) in
            
            for item in snapshot.children
            {
                
               // if
                let snap = item as! DataSnapshot
                let dic = snap.value as! Dictionary<String,AnyObject>
                if let name = dic["name"] as! String!
               {
                    let name = dic["name"] as! String!
                    let email = dic["email"] as! String!
                    let photoURL = dic["photoURL"] as? String ?? ""
                }
                
            }
            
            //let user = mUser(name: name!, email: email!, photoURL: photoURL, uid: userID!)
        })
        }
        
    }
    
    @IBAction func addUserButtonClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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
