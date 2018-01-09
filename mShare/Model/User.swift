//
//  File.swift
//  mShare
//
//  Created by Manikandan V Nair on 04/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import Foundation
import FirebaseAuth

class mUser
{
    var name:String!
    var email:String!
    var photoURL:URL?
    var uid:String!
    
    init(authData: User)
    {
        uid = authData.uid
        name = authData.displayName!
        email = authData.email!
        photoURL = authData.photoURL
       
        
    }
    
    init(name: String, email: String, photoURL: String, uid: String)
    {
        self.name = name
        self.email = email
        self.photoURL = URL(fileURLWithPath: photoURL)
        self.uid = uid
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "email": email,
            "photoURL": photoURL?.absoluteString
        ]
    }
    

    
}
