//
//  PaidView.swift
//  mShare
//
//  Created by Manikandan V Nair on 18/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase

class PaidView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var memberList:[mUser] = []
    var listTableView:UITableView = UITableView()
    var didSelectedItem: ((mUser)->Void)?
    let common = Common()
    let rowHeight  = 60
    let pading = 30
    let cellIdentifier = "paidUserList"
    
    init(group:Group, view: UIView)
    {
        super.init(frame: CGRect(x: 10, y: 150, width: Int(view.frame.size.width - 20) , height: 100))
        
        listTableView.register(PaidUserTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        listTableView.register(UINib(nibName: "PaidUserTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        
       
        self.addSubview(listTableView)
        
        let nvActivity = common.setActitvityIndicator(inView: self)
        nvActivity.startAnimating()
        common.getMembersList(from: group) { (mList) in
            
            self.memberList = mList
            DispatchQueue.main.async {
                self.listTableView.reloadData()
                nvActivity.stopAnimating()
                self.setFrame(view: view)
                
            }
        }
        
        
        
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Paid by"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:PaidUserTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PaidUserTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "PaidUserTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PaidUserTableViewCell)!
        }
        
        cell.setUserData(user: memberList[indexPath.row])
        
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedObj = memberList[indexPath.row]
        
        if let handler = didSelectedItem {
            handler(selectedObj)
        }
    }
    
 
    func setFrame(view: UIView)
    {
        var height = memberList.count * rowHeight + pading
        let frameHeight = view.frame.size.height - 2 * self.frame.size.height
        if height >= Int(frameHeight)
        {
            height = Int(frameHeight)
        }
        self.frame = CGRect(x: 10, y: 150, width: Int(view.frame.size.width - 20), height: height)
        self.listTableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height )
        common.dropShadow(color: .black, view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
