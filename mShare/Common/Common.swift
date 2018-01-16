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

let GROUP = "Groups"
let USERS = "Users"
let NameTag = 1, EmailTag = 2, PhotoTag = 3

let Font = "Kefa"
let FontSize = 16

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

    
}
