//
//  AgeViewController.swift
//  Age
//
//  Created by Amin on 2019-05-23.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class AgeViewController: BaseViewController {
    
    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ageCalculator = AgeCalculator(birthDate: UserDefaultsUtil.defaultBirthday!.birthDate)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(refreshAge),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Properties
    
    private var ageCalculator: AgeCalculator = AgeCalculator(birthDate: UserDefaultsUtil.defaultBirthday!.birthDate)
    private var timer: Timer?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var ageLabel: UILabel!
    
    // MARK: - Methods
    
    @objc private func refreshAge() {
        guard isViewLoaded else {
            return
        }
        
        ageLabel.text = String(format: "%10.8f", ageCalculator.currentAge.value)
    }
    
    // MARK: - Actions
    
    @IBAction func agesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ages", sender: nil)
    }
    
}
