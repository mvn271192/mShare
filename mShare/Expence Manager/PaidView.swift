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
    var isMultipleSplit:Bool = false
    
    let common = Common()
    let rowHeight  = 60
    let pading = 30
    let buttonHeight = 40
    let cellIdentifier = "paidUserList"
    
    let multipleButtonTag = 10
    let multipleLabelTag = 11
    
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
        
        if (self.isMultipleSplit)
        {
            return "Enter share of each person"
        }
        else
        {
            return "Paid by"
        }
        
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
        
        cell.setUserData(user: memberList[indexPath.row],isMultiple: self.isMultipleSplit)
        
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedObj = memberList[indexPath.row]
        
        if let handler = didSelectedItem {
            handler(selectedObj)
        }
    }
    
    // MARK: - Actions
    @objc func enableMultipleSplit(sender: AnyObject)
    {
        self.isMultipleSplit = !self.isMultipleSplit
        let btn = sender as! UIButton
        let displayLabel = self.viewWithTag(multipleLabelTag)
        if (displayLabel == nil)
        {
            self.setMultiSplitLabel(button: btn)
        }
        if (isMultipleSplit)
        {
            
            btn.setTitle("Single Person", for: .normal)
            displayLabel?.isHidden = false
        }
        else
        {
            btn.setTitle("Multiple people", for: .normal)
            displayLabel?.isHidden = true
        }
        listTableView.reloadData()
    }
    
 
    func setFrame(view: UIView)
    {
        self.backgroundColor = UIColor.white
        var height = memberList.count * rowHeight + buttonHeight + pading
        let frameHeight = view.frame.size.height - 2 * self.frame.size.height
        if height >= Int(frameHeight)
        {
            height = Int(frameHeight)
        }
        self.frame = CGRect(x: 10, y: 150, width: Int(view.frame.size.width - 20), height: height)
        self.listTableView.frame = CGRect(x: 0, y: 0, width: Int(self.frame.size.width), height: height - buttonHeight)
        self.setMultipleSplitButton()
        common.dropShadow(color: .black, view: self)
    }
    
    func setMultipleSplitButton()
    {
        let multipleSplitButton:UIButton = UIButton()
        multipleSplitButton.setTitle("Multiple people", for: .normal)
        multipleSplitButton.setTitleColor(UIColor(red: 71/255, green: 169/255, blue: 106/255, alpha: 1), for: .normal)
        multipleSplitButton.frame = CGRect(x: 10, y: Int(listTableView.frame.size.height ), width: 160, height: buttonHeight)
        multipleSplitButton.addTarget(self, action:#selector(enableMultipleSplit), for: .touchUpInside)
        multipleSplitButton.titleLabel?.font = FontForTextField
        multipleSplitButton.tag = multipleButtonTag
        multipleSplitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.addSubview(multipleSplitButton)
        
       
        
    }
    
    func setMultiSplitLabel(button: UIButton)
    {
        let splitLabel:UILabel = UILabel()
        splitLabel.frame = CGRect(x: button.frame.size.width , y: button.frame.origin.y, width: self.frame.size.width - button.frame.size.width, height: 40)
        splitLabel.font = UIFont(name:Font , size: 15)
        splitLabel.text = "Total: $0.00 of $0.00"
        splitLabel.lineBreakMode = .byCharWrapping
       // splitLabel.backgroundColor = UIColor.yellow
        splitLabel.tag = multipleLabelTag
        self.addSubview(splitLabel)
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
