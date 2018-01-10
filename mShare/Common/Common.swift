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
    
}
