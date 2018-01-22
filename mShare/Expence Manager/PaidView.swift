//
//  PaidView.swift
//  mShare
//
//  Created by Manikandan V Nair on 18/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import Firebase

class PaidView: UIView, UITableViewDelegate, UITableViewDataSource, PaidUserCellDelegate{
    
    
    
    var memberList:[mUser] = []
    var listTableView:UITableView = UITableView()
    var didSelectedItem: ((mUser)->Void)?
    var isMultipleSplit:Bool = false
    var totalAmount:Float = 0.0
    var grantTotal:Float = 0.0
    let splitLabel:UILabel = UILabel()
    var userAmt:[Dictionary<String,Any>] = []
    
    let common = Common()
    let rowHeight  = 60
    let pading = 30
    let buttonHeight = 40
    let cellIdentifier = "paidUserList"
    
    let multipleButtonTag = 10
    let multipleLabelTag = 11
    let saveButtonTag = 12
    
    init(group:Group, view: UIView, total: Float)
    {
        super.init(frame: CGRect(x: 10, y: 150, width: Int(view.frame.size.width - 20) , height: 100))
        grantTotal = total
        listTableView.register(PaidUserTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        listTableView.register(UINib(nibName: "PaidUserTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        
        self.addSubview(listTableView)
        
        let nvActivity = common.setActitvityIndicator(inView: self)
        nvActivity.startAnimating()
        common.getMembersList(from: group) { (mList) in
            
            self.memberList = mList
            for item in self.memberList
            {
                let dic = ["user":item.uid, "amount":0.0, "userShare":0.0] as [String : Any]
                self.userAmt.append(dic)
                
            }
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
        cell.delegate = self
        
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedObj = memberList[indexPath.row]
        
        if let handler = didSelectedItem {
            handler(selectedObj)
        }
    }
    
    // MARK: - Cell Delegates
    
    func textField(textField: UITextField, currentValue: String, user: mUser) {
    
        var f = (userAmt.filter { $0["user"] as? String == user.uid }).first! as Dictionary<String, AnyObject>
        let index = userAmt.index{$0["user"] as? String == user.uid }
        guard index != NSNotFound  else {
            return
        }
        let currentAmt = f["amount"] as! Float
        if let newAmt = Float(currentValue)
        {
           totalAmount += newAmt - currentAmt
           let userShare = newAmt - grantTotal/Float(memberList.count)
           userAmt[index!].updateValue(userShare, forKey: "userShare")
           userAmt[index!].updateValue(Float(currentValue) as AnyObject, forKey: "amount")
            
            splitLabel.text = "Total: $\(totalAmount) of $\(grantTotal)"
            if (totalAmount != grantTotal)
            {
                splitLabel.textColor = UIColor.orange
            }
            else
            {
                splitLabel.textColor = UIColor.black
            }
        }
      
        
    }
    
    // MARK: - Actions
    @objc func enableMultipleSplit(sender: AnyObject)
    {
        var frameHeight = 0
        
    
        self.isMultipleSplit = !self.isMultipleSplit
        let btn = sender as! UIButton
        let displayLabel = self.viewWithTag(multipleLabelTag)
        if (displayLabel == nil)
        {
            self.setMultiSplitLabel(button: btn)
        }
        if (isMultipleSplit)
        {
            frameHeight = buttonHeight
            btn.setTitle("Single Person", for: .normal)
            displayLabel?.isHidden = false
            
        }
        else
        {
            frameHeight = -buttonHeight
            btn.setTitle("Multiple people", for: .normal)
            displayLabel?.isHidden = true
        }
        
        var frame = self.frame
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            frame.size.height += CGFloat(frameHeight)
            self.frame = frame
            self.backgroundColor = .white
            if (frameHeight < 0)
            {
              self.common.dropShadow(color: .black, view: self)
                self.setSaveButton(isEnable: self.isMultipleSplit)
            }
            
        }, completion: { (finished: Bool) in
            if (frameHeight > 0)
            {
                self.common.dropShadow(color: .black, view: self)
                self.setSaveButton(isEnable: self.isMultipleSplit)
            }
            
        })
        
        
        listTableView.reloadData()
    }
    
    @objc func saveButtonClick(sender: AnyObject)
    {
        
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
        multipleSplitButton.frame = CGRect(x: 10, y: Int(listTableView.frame.size.height ), width: 140, height: buttonHeight)
        multipleSplitButton.addTarget(self, action:#selector(enableMultipleSplit), for: .touchUpInside)
        multipleSplitButton.titleLabel?.font = FontForTextField
        multipleSplitButton.tag = multipleButtonTag
        multipleSplitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.addSubview(multipleSplitButton)
        
       
        
    }
    
    func setMultiSplitLabel(button: UIButton)
    {
        splitLabel.frame = CGRect(x: button.frame.size.width , y: button.frame.origin.y, width: self.frame.size.width - button.frame.size.width, height: 40)
        splitLabel.font = UIFont(name:Font , size: 15)
        splitLabel.text = "Total: $0.00 of $\(grantTotal)"
        splitLabel.lineBreakMode = .byCharWrapping
       // splitLabel.backgroundColor = UIColor.yellow
        splitLabel.tag = multipleLabelTag
        self.addSubview(splitLabel)
    }
    
    func setSaveButton(isEnable: Bool)
    {
        if (!isEnable)
        {
            if let btn = self.viewWithTag(saveButtonTag)
            {
                btn.removeFromSuperview()
                return
            }
            
        }
        let saveButton:UIButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor(red: 71/255, green: 169/255, blue: 106/255, alpha: 1), for: .normal)
        saveButton.frame = CGRect(x: Int(self.frame.size.width - CGFloat(80)), y: Int(self.frame.size.height - CGFloat(buttonHeight)), width: 80, height: buttonHeight)
        saveButton.addTarget(self, action:#selector(saveButtonClick), for: .touchUpInside)
        saveButton.titleLabel?.font = FontForTextField
        saveButton.tag = saveButtonTag
        saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.addSubview(saveButton)
        
        
        
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
