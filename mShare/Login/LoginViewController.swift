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
import FirebaseAuthUI
import FirebaseGoogleAuthUI


class LoginViewController: UIViewController ,FUIAuthDelegate{
    
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
  
// MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        checkLoggedIn()

        signInButton .addTarget(self, action:#selector(signInButtonClick(_:)), for: .touchUpInside)
       
    }
    
    @objc func signInButtonClick(_ sender :AnyObject)
    {

        do {
           let authUI = FUIAuth.defaultAuthUI()
           try authUI!.signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        
    
    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                let photoURL = user?.photoURL
                let data = try? Data(contentsOf: photoURL!)
                if let imgData = data
                {
                   self.performSegue(withIdentifier: "tabViewController", sender: user)
                    let image = UIImage(data: imgData)
                    let name = user?.displayName
                    let userId = user?.email
                }
                
                
                
                
                
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        let googleProvider = FUIGoogleAuth()
       // let facebookProvider = FIRFacebookAuthUI(appID: kFacebookAppID)
        authUI?.delegate = self
        authUI?.providers = [googleProvider]
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    // MARK: - Auth Delegates
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
        if error != nil {
            //Problem signing in
            login()
        }else {
            self.performSegue(withIdentifier: "tabViewController", sender: user)
            //User is in! Here is where we code after signing in
            let name = user?.displayName
            let userId = user?.email
            let photourl = user?.photoURL
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let user = sender as? User
        {
            let vcTab = segue.destination as! UITabBarController
            let dashVC = vcTab.viewControllers![0] as! DashBoardViewController
            dashVC.user = user
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
