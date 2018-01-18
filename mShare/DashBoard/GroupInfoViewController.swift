//
//  GroupInfoViewController.swift
//  mShare
//
//  Created by Manikandan V Nair on 06/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit

class GroupInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    // MARK: - View Life Cycle
    
    var selectedGroup:Group!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var taskListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedGroup.name

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func addTaskButtonClick(_ sender: Any)
    {
        self.performSegue(withIdentifier: "addExpence", sender: selectedGroup)
    }
    
    @IBAction func balanceButtonClick(_ sender: Any)
    {
    }
    
    @IBAction func editButtonClick(_ sender: Any)
    {
        self.performSegue(withIdentifier: "groupSetting", sender: selectedGroup)
    }
    
    @IBAction func backButtonClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "groupSetting")
        {
            let selectedGrp = sender as! Group
            let navVC = segue.destination as! UINavigationController
            let grpsettingVC = navVC.topViewController as! GroupSettingViewController
            grpsettingVC.selectedGroup = selectedGrp
            
        }
        
        else if (segue.identifier == "addExpence")
        {
            let selectedGrp = sender as! Group
            let navVC = segue.destination as! UINavigationController
            let expenceVC = navVC.topViewController as! AddExpenceViewController
            expenceVC.selectedGroup = selectedGrp
        }
    }
 

}
