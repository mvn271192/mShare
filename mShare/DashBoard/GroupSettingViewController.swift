//
//  GroupSettingViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 09/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit

class GroupSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var memberListTableView: UITableView!
    @IBOutlet weak var groupNameTextField: UITextField!
    var selectedGroup:Group!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameTextField.text = selectedGroup.name

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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
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
