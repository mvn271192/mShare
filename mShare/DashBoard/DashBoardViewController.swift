//
//  DashBoardViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 03/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseDatabase
import NVActivityIndicatorView
import Toast_Swift

let GROUP = "Groups"
let USERS = "Users"



class DashBoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var eMailLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    private lazy var databaseRef: DatabaseReference = Database.database().reference()
    
    var groupList:[Group] = []
    
    
    var user:mUser!
    {
        didSet
        {
            
            
        }
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeGroups()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setProfilePic()
    }
    
    // MARK: - Firebase Operatons
    
    func createGroup(with name:String) -> String
    {
        let members = [
            user.uid:true,]
        let groupRef = databaseRef.child(GROUP)
        let userRef = databaseRef.child(USERS).child(user.uid)
        let groupData = [
            "name": name,
            "members": members,
            "createdBy":user.uid,
            ] as [String : Any]
        let groupHandle = groupRef.childByAutoId()
        groupHandle.setValue(groupData)
        groupHandle.setValue(groupData) { (error, databaseRef) in
            if error == nil
            {
                userRef.child(GROUP).child(groupHandle.key).setValue(true)
                self.view.makeToast("Group added")
            }
            
        }
        let  key = groupHandle.key
        
        //update group info in user
        
        
        
        return key
    }
    
    private func observeGroups()
    {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        
        let nvactivity = NVActivityIndicatorView(frame: CGRect(x: 0
            , y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.green, padding: 0)
        self.view.addSubview(nvactivity)
        self.view.bringSubview(toFront: nvactivity)
        nvactivity.center = self.view.center
        nvactivity.startAnimating()
        
        //queryStarting(atValue: true, childKey: user.uid)
        
        let grpRef = databaseRef.child(GROUP)
        let userRef = databaseRef.child(USERS)
        let grpInUserRef = userRef.child(user.uid).child(GROUP)
        
        grpInUserRef.queryOrderedByKey().observeSingleEvent(of: .value) { (snap) in
            
            if snap.childrenCount == 0
            {
                nvactivity.stopAnimating()
                self.view.makeToast("No Groups found")
                return
            }
            
            for item in snap.children
            {
                let grpValue = item as! DataSnapshot
                grpRef.child(grpValue.key).observe(DataEventType.value, with: { (grpSnapshot) in
                    
                    
                    let grp = Group(snapshot: grpSnapshot)
                    self.groupList.append(grp)
                    
                    DispatchQueue.main.async
                        {
                            self.groupTableView.reloadData()
                            nvactivity.stopAnimating()
                    }
                    
                })
                
                
            }
        }
        
        //        databaseRef.child(GROUP).queryOrdered(byChild: "createdBy").queryEqual(toValue: user.uid).observeSingleEvent(of: .value) { (data) in
        //
        //            for item in data.children
        //            {
        //                let snapshot = item as! DataSnapshot
        //                let grp = Group(snapshot: snapshot)
        //                self.groupList.append(grp)
        //
        //
        //            }
        //            self.groupTableView.reloadData()
        //            DispatchQueue.main.async
        //                {
        //                nvactivity.stopAnimating()
        //            }
        //        }
        
        
        
    }
    
    
    func getUserFrom(uId :String!, completionHandler:@escaping (mUser) -> ())
    {
        let userID = uId
        databaseRef.child(USERS).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value!["name"] as! String!
            let email = value!["email"] as! String!
            let photoURL = value?["photoURL"] as? String ?? ""
            let user = mUser(name: name!, email: email!, photoURL: photoURL, uid: userID!)
            
            completionHandler(user)
            // ...
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    
    // MARK: - Functions
    
    
    func setProfilePic()
    {
        userNameLabel?.text = user.name
        eMailLabel?.text = user.email
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 5, y: 5, width: 46, height: 46)
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.orange
        profilePic.addSubview(activityIndicator)
        DispatchQueue.global(qos: .background).async {
            
            let photoURL = self.user?.photoURL
            if let url = photoURL {
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    if let imgData = data
                    {
                        let image = UIImage(data: imgData)
                        self.profilePic?.image = image
                        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2
                        self.profilePic.layer.masksToBounds = true
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func createGroupButtonClick(_ sender: Any)
    {
        let alert = UIAlertController(title: "mShare", message: "Enter Group Name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            guard let text = textField?.text, text.count > 0 else {
                return
            }
            
            let key = self.createGroup(with: text)
            let group = Group(name: text, createdBy: self.user.uid, members: [self.user.uid], gId: key, photoURL: "")
            self.groupList.append(group)
            
            self.groupTableView.beginUpdates()
            self.groupTableView.insertRows(at: [NSIndexPath(row: self.groupList.count - 1, section: 0) as IndexPath], with: .fade)
            self.groupTableView.endUpdates()
            
            //            self.groupTableView.reloadData()
            
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonClick(_ sender: Any)
    {
        do {
            let authUI = FUIAuth.defaultAuthUI()
            try authUI!.signOut()
            self.dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "groupInfo")
        {
            let grp = sender as! Group
            let navVC = segue.destination as! UINavigationController
            let grpInfoVC = navVC.topViewController as! GroupInfoViewController
            grpInfoVC.selectedGroup = grp
            
        }
    }
    
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Groups"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        cell.setData(group: groupList[indexPath.row] )
        return cell
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedGroup = groupList[indexPath.row]
        self.performSegue(withIdentifier: "groupInfo", sender: selectedGroup)
    }
    
}




