//
//  RootViewController.swift
//  Age
//
//  Created by Amin on 2019-05-25.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    var appStatusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Life Cycle
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return appStatusBarStyle }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
}
