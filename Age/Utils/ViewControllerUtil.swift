//
//  ViewControllerUtil.swift
//  Age
//
//  Created by Amin on 2019-06-03.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isViewVisible: Bool {
        return isViewLoaded && view.window != nil
    }
    
}
