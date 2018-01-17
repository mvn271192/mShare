//
//  GroupSettingViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 09/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SkyFloatingLabelTextField

class GroupSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,AddUserProtocol{
 
    

    @IBOutlet weak var memberListTableView: UITableView!
    @IBOutlet weak var groupNameTextField: SkyFloatingLabelTextField!
    var selectedGroup:Group!
    
    var membersList:[mUser] = []
    private lazy var databaseRef: DatabaseReference = Database.database().reference()
    let common:Common = Common()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameTextField.text = selectedGroup.name
        getMembersList(from: selectedGroup)
        
        groupNameTextField.titleLabel.font = UIFont(name: Font, size: CGFloat(FontSize))
        groupNameTextField.placeholderFont = UIFont(name: Font, size: CGFloat(FontSize))
        

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    
    @IBAction func backButtonClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonClick(_ sender: Any)
    {
    }
    
    @IBAction func deleteGroupButtonClick(_ sender: Any)
    {
    }
    
    @IBAction func addUserButtonClick(_ sender: Any)
    {
        self.performSegue(withIdentifier: "addUser", sender: selectedGroup)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: Font, size: CGFloat(FontSize+1))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userList", for: indexPath) as! UserListTableViewCell
        cell.setUserData(user: membersList[indexPath.row])
        
        return cell
    }
    
    // MARK: - AddUser delegates
    
    func userAddedtoGroup(user: mUser) {
        
        if  membersList.contains(where: { $0.email == user.email })
        {
            return
        }
        else
        {
            membersList.append(user)
            
            memberListTableView.beginUpdates()
            memberListTableView.insertRows(at: [NSIndexPath(row: membersList.count - 1, section: 0) as IndexPath], with: .fade)
            memberListTableView.endUpdates()
            
        }
        
    }
    
     // MARK: - Functions
    
    func getMembersList(from group:Group)
    {
        var j:Int = 0
        var i:Int = 0
        
        let nvActicity = common.setActitvityIndicator(inView: self.view)
        nvActicity.startAnimating()
        
        let grpMembersRef = databaseRef.child(GROUP).child(group.gId).child("members")
        let userRef = databaseRef.child(USERS)
        grpMembersRef.observe(DataEventType.childAdded, with: { (snapshot) in
           j += 1
        
            let user = snapshot as DataSnapshot
            userRef.child(user.key).observe(DataEventType.value, with: { (userSnap) in
                let value = userSnap.value as? NSDictionary
                let name = value!["name"] as! String!
                let email = value!["email"] as! String!
                let photoURL = value?["photoURL"] as? String ?? ""
                let user = mUser(name: name!, email: email!, photoURL: photoURL, uid: userSnap.key)
                self.membersList.append(user)
                i += 1
                if (i == j)
                {
                    DispatchQueue.main.async
                        {
                            self.memberListTableView.reloadData()
                            nvActicity.stopAnimating()
                    }
                }
            })
        })
        
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "addUser")
        {
            let grp = sender as! Group
            let addUserVC = segue.destination as! AddUserViewController
            addUserVC.selectedGroup = grp
            addUserVC.delegate = self
            
            
        }
    }
 

}
