//
//  CurrencySelector.swift
//  mShare
//
//  Created by Manikandan V. Nair on 18/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit

class CurrencySelector: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var currencyTypeList:[Currency] = []
    var listTableView:UITableView = UITableView()
    var didSelectedItem: ((Currency)->Void)?
    
    init(view: UIView)
    {
        
        super.init(frame: CGRect(x: 10, y: 150, width: view.frame.size.width - 20 , height: view.frame.size.height - 150))
        self.listTableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
        self .addSubview(listTableView)
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "listCell")
        
        let c1 = Currency(name: "INR", country: "Indian Rupee(₹)", id: 1, symbol: "₹")
        let c2 = Currency(name: "USD", country: "US Dollar($)", id: 2, symbol: "$")
        let c3 = Currency(name: "AED", country: "UAE Diraham(₹)", id: 3, symbol: "DH")
        let c4 = Currency(name: "XPF", country: "CFP France(F)", id: 4, symbol: "F")
        let c5 = Currency(name: "AUD", country: "Australian Doller($)", id: 5, symbol: "$")
        let c6 = Currency(name: "BTC", country: "Bit Coin(฿)", id: 6, symbol: "฿")
        
        currencyTypeList.append(c1)
        currencyTypeList.append(c2)
        currencyTypeList.append(c3)
        currencyTypeList.append(c4)
        currencyTypeList.append(c5)
        currencyTypeList.append(c6)
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        listTableView.reloadData()
        
        
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Currency List"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencyTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        cell.textLabel?.text = currencyTypeList[indexPath.row].getCurrencyName()
        cell.textLabel?.font = FontForTextField
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedObj = currencyTypeList[indexPath.row]
        
        if let handler = didSelectedItem {
            handler(selectedObj)
        }
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
