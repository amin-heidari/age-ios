//
//  LoadingViewController.swift
//  Age
//
//  Created by Amin on 2019-05-20.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: - Constants/Types
    
    private enum FailureScenario {
        case generic
        case connection
        case certificate
    }
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        RemoteConfigManager.shared.fetchConfig { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .failure(let error):
                switch (error) {
                case AppError.connection:
                    // Not connected to the internet.
                    _ = 1
                case AppError.certificateExpired:
                    // Please udpate the app.
                    _ = 1
                default:
                    // Generic message.
                    _ = 1
                }
            case .success(let remoteConfig):
                _ = remoteConfig
                if (Bundle.main.versionNumber.compare(remoteConfig.version.minimum, options: .numeric) == .orderedAscending) {
                    // The app's version is below the minimum required version.
                    self.performSegue(withIdentifier: "upgrade", sender: nil)
                } else if (Bundle.main.versionNumber.compare(remoteConfig.version.latest, options: .numeric) == .orderedAscending) {
                    // The app's version is below the latest version.
                    if let skippedVersion = UserDefaultsUtil.skippedLatestVersion, skippedVersion.compare(remoteConfig.version.latest, options: .numeric) == .orderedSame {
                        // User has already skipped to upgrade to that version before.
                        self.proceedToTheApp()
                    } else {
                        // User has never skipped an upgrade to this version.
                        self.performSegue(withIdentifier: "upgrade", sender: nil)
                    }
                } else {
                    self.proceedToTheApp()
                }
            }
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    private func proceedToTheApp() {
        if let _ = UserDefaultsUtil.defaultBirthday {
            performSegue(withIdentifier: "age", sender: nil)
        } else {
            performSegue(withIdentifier: "add-age", sender: nil)
        }
    }
    
    // MARK: - Delegate
    
    // MARK: - Delegate

}
