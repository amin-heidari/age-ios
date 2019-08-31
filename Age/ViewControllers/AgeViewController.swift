//
//  AgeViewController.swift
//  Age
//
//  Created by Amin on 2019-05-23.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

class AgeViewController: BaseViewController, StoreManagerDelegate {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreManager.shared.delegate = self
        StoreManager.shared.startProductRequest(with: [Constants.Store.multipleAgeProductId])
        
        if let _ = UserDefaultsUtil.multipleAgesIAPTransactionId {
            agesButton.isHidden = false
        }
        
        // Setting these in code here since the IB doesn't respond well to these color asset changes.
        backgroundGradientView.startColor = .primary
        backgroundGradientView.endColor = .accent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ageCalculator = AgeCalculator(birthDate: SuiteDefaultsUtil.defaultBirthday!.birthDate)
        
        timer = Timer.scheduledTimer(timeInterval: Constants.AgeCalculation.refreshInterval,
                                     target: self,
                                     selector: #selector(refreshAge),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        ageCalculator = nil
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Properties
    
    override var isNavigationBarHidden: Bool { return true }
    
    private var ageCalculator: AgeCalculator?
    private var timer: Timer?
    
    // MARK: - Outlets
    
    @IBOutlet weak var backgroundGradientView: GradientView!
    
    @IBOutlet private weak var ageLabel: UILabel!
    
    @IBOutlet private weak var agesButton: UIButton!
    
    // MARK: - Methods
    
    @objc private func refreshAge() {
        guard let calculator = ageCalculator, isViewLoaded, let _ = view.window else {
            return
        }
        
        ageLabel.text = String(format: "%.8f", calculator.currentAge.value)
    }
    
    // MARK: - Actions
    
    @IBAction func agesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ages", sender: nil)
    }
    
    // MARK: - StoreManagerDelegate
    
    func storeManagerDidReceiveMessage(_ message: String) { }
    
    func storeManagerDidReceiveResponse(_ response: [StoreManager.Section]) {
        if (UserDefaultsUtil.multipleAgesIAPTransactionId == nil) {
            if StoreManager.shared.availableProducts.contains(where: { (product) -> Bool in
                product.productIdentifier == Constants.Store.multipleAgeProductId
            }) && StoreObserver.shared.isAuthorizedForPayments {
                agesButton.isHidden = false
            } else {
                agesButton.isHidden = true
            }
        }
    }
    
}
