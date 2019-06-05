//
//  UpgradeViewController.swift
//  Age
//
//  Created by Amin on 2019-06-01.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class UpgradeViewController: BaseViewController {

    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch RemoteConfigManager.shared.remoteConfig.version.compare(appVersion: Bundle.main.versionNumber) {
        case .forcedUpgrade:
            upgradeTitleLabel.text = "Please upgrade to latest version."
            upgradeDescriptionLabel.text = "You need to upgrade to the latest version of this application to enjoy all the super coolness of it."
            skipButton.isHidden = true
        case .optionalUpgrade:
            upgradeTitleLabel.text = "There's a new version available :)"
            upgradeDescriptionLabel.text = "We recommend you upgrade to the latest version of this application to enjoy all the super coolness of it."
            skipButton.isHidden = false
        default:
            fatalError("Not supported!")
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var upgradeTitleLabel: UILabel!
    @IBOutlet weak var upgradeDescriptionLabel: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Methods
    
    // MARK: - Actions

    @IBAction func upgradeButtonTapped(_ sender: Any) {
        let url = URL(string: RemoteConfigManager.shared.remoteConfig.storeURL)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(
                title: "Cannot open App Store",
                message: "We failed to open App Store. Please open it yourself.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        assert(RemoteConfigManager.shared.remoteConfig.version.compare(appVersion: Bundle.main.versionNumber) != .forcedUpgrade)
        
        if let _ = UserDefaultsUtil.defaultBirthday {
            performSegue(withIdentifier: "age", sender: nil)
        } else {
            performSegue(withIdentifier: "add-age", sender: nil)
        }
    }
    
}
