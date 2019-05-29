//
//  LoadingViewController.swift
//  Age
//
//  Created by Amin on 2019-05-20.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        RemoteConfigManager.shared.fetchConfig { (result) in
            switch result {
            case .failure(let error):
                _ = error
            case .success(_):
                let a = 3
                _ = a
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
