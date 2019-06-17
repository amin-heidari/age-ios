//
//  BaseViewController.swift
//  Age
//
//  Created by Amin on 2019-06-03.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Properties
    
    var isNavigationBarHidden: Bool { return false }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions

}
