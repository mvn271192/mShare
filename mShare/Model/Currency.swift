//
//  Currency.swift
//  mShare
//
//  Created by Manikandan V. Nair on 18/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import Foundation

class Currency
{
    var name:String!
    var country:String!
    var id:Int!
    var symbol:String!
    
    init(name: String, country: String, id: Int, symbol: String)
    {
        self.name = name
        self.country = country
        self.id = id
        self.symbol = symbol
    }
    
    func getCurrencyName() -> String
    {
        var displayName = ""
        displayName.append("\(self.name!) - \(self.country!)")
        return displayName
    }
}
