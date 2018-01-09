//
//  File.swift
//  mShare
//
//  Created by Manikandan V Nair on 05/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Group {
    
    var name:String!
    var gId:String!
    var createdBy:String!
    var members:[String]?
    var photoURL:URL?
    
    init(name: String ,createdBy: String, members: [String], gId: String, photoURL:String)
    {
        self.name = name
        self.createdBy = createdBy
        self.members = members
        self.gId = gId
        self.photoURL = URL(fileURLWithPath: photoURL)
        
    }
    
    init(snapshot snap:DataSnapshot!)
    {
        if let data = snap {
            let grpId = data.key
            let grpData = data.value as! Dictionary<String,AnyObject>
            
            if let name = grpData["name"] as! String!, name.count > 0
            {
                let members = grpData["members"] as! Dictionary<String,Bool>
                self.name = name
                self.createdBy = grpData["createdBy"] as! String!
                if let arrayMembers = Array(members.keys) as [String]!
                {
                    self.members = arrayMembers
                }
                else
                {
                    self.members = []
                }
                
                self.gId = grpId
                self.photoURL = URL(fileURLWithPath: grpData["photoURL"] as? String ?? "")
                
                
            }
        }
       
    }
}

