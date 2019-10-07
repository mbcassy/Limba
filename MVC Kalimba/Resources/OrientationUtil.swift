//
//  OrientationUtil.swift
//  MVC Kalimba
//
//  Created by Cassy on 9/11/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import Foundation
import UIKit

struct OrientationLocks{
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}
