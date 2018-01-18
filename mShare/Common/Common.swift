//
//  Common.swift
//  mShare
//
//  Created by Manikandan V. Nair on 10/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import Toast_Swift
import UIKit
import DynamicBlurView
import Firebase
import FirebaseDatabase

let GROUP = "Groups"
let USERS = "Users"
let NameTag = 1, EmailTag = 2, PhotoTag = 3

let Font = "Kefa"
let FontSize = 16
let FontForTextField = UIFont (name: Font, size: CGFloat(FontSize))

struct Common {
    
    func setActitvityIndicator(inView view:UIView)->NVActivityIndicatorView
    {
        let nvactivity = NVActivityIndicatorView(frame: CGRect(x: 0
            , y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.green, padding: 0)
        view.addSubview(nvactivity)
        view.bringSubview(toFront: nvactivity)
        nvactivity.center = view.center
        
        return nvactivity
    }
    
    func dropShadow(color: UIColor, view: UIView, radius: CGFloat = 1, scale: Bool = true) {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = radius
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func getBlurEffectView(view: UIView)->DynamicBlurView
    {

        
        let blurView = DynamicBlurView(frame: view.bounds)
        blurView.blurRadius = 10
        
        return blurView
    }
    
    func getMembersList(from group:Group, completionHandler:@escaping ([mUser]) -> ())
    {
        var j:Int = 0
        var i:Int = 0
        
        var memberList:[mUser] = []
        let grpMembersRef = Database.database().reference().child(GROUP).child(group.gId).child("members")
        let userRef = Database.database().reference().child(USERS)
        grpMembersRef.observe(DataEventType.childAdded, with: { (snapshot) in
            j += 1
            
            let user = snapshot as DataSnapshot
            userRef.child(user.key).observe(DataEventType.value, with: { (userSnap) in
                let value = userSnap.value as? NSDictionary
                let name = value!["name"] as! String!
                let email = value!["email"] as! String!
                let photoURL = value?["photoURL"] as? String ?? ""
                let user = mUser(name: name!, email: email!, photoURL: photoURL, uid: userSnap.key)
                memberList.append(user)
                i += 1
                if (i == j)
                {
                    DispatchQueue.main.async
                        {
                            completionHandler(memberList)
                    }
                }
            })
        })
        
        
    }

    
}
