//
//  LoginViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 02/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth


class LoginViewController: UIViewController ,GIDSignInUIDelegate{
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("error due to \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        // ...
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        signInButton .addTarget(self, action:#selector(signInButtonClick(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func signInButtonClick(_ sender :AnyObject)
    {
       
//        Auth.auth().signIn(with: credential) { (user, error) in
//
//            // User is signed in
//            // ...
//        }
        
        let firebaseAuth = Auth.auth()
        do {
             try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
