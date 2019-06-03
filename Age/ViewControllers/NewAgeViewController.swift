//
//  NewAgeViewController.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class NewAgeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveButtonTapped(_ sender: Any) {
//        _ = DatabaseManager.shared.addBirthday(Birthday(birthDate: Date(), name: "Amin"))
        _ = DatabaseManager.shared.addBirthday(Birthday(birthDate: Date(), name: "Amin")) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }

}
