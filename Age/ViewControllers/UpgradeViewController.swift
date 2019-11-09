//
//  UpgradeViewController.swift
//  Age
//
//  Created by Amin on 2019-06-01.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import AgeData

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
            upgradeDescriptionLabel.text = "You need to upgrade to the latest version of the application in order to continue using the app."
            skipButton.isHidden = true
        case .optionalUpgrade:
            upgradeTitleLabel.text = "There's a new version available :)"
            upgradeDescriptionLabel.text = "There’s a newer, cooler version of the application available on the store."
            skipButton.isHidden = false
        default:
            fatalError("Not supported!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewAgeViewController {
            destination.scenario = .newDefault
        }
    }
    
    // MARK: - Properties
    
    override var isNavigationBarHidden: Bool { return true }
    
    // MARK: - Outlets
    @IBOutlet private weak var upgradeTitleLabel: UILabel!
    @IBOutlet private weak var upgradeDescriptionLabel: UILabel!
    @IBOutlet private weak var upgradeButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    
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
        
        UserDefaultsUtil.skippedLatestVersion = RemoteConfigManager.shared.remoteConfig.version.latest
        
        if let _ = SuiteDefaultsUtil.defaultBirthday {
            performSegue(withIdentifier: "age", sender: nil)
        } else {
            performSegue(withIdentifier: "add-age", sender: nil)
        }
    }
    
}
