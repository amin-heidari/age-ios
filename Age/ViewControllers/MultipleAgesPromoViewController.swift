//
//  MultipleAgesPromoViewController.swift
//  Age
//
//  Created by Amin on 2019-07-16.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class MultipleAgesPromoViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    enum Result {
        case dismiss
        case purchase
        case restore
    }
    
    // MARK: - Static
    
    // MARK: - API
    
    var finish: Finish<Result>?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Methods
    
    @IBAction func purchaseTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.finish?(.purchase)
        }
    }
    
    @IBAction func restoreTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.finish?(.restore)
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.finish?(.dismiss)
        }
    }
    
    
    // MARK: - Actions

}
