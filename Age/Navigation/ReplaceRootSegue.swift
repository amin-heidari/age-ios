//
//  ReplaceRootSegue.swift
//  Age
//
//  Created by Amin on 2019-06-01.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

/// This segue replaces the whole navigation stack with the destination.
/// Used for example in the launch process of the app where view controllers are no longer needed once they are navigated away from.
class ReplaceRootSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        guard let nc = src.navigationController else {
            assertionFailure("This segue only supports navigation controller stacks.")
            return
        }
        DispatchQueue.main.async {
            nc.setViewControllers([dst], animated: true)
        }
    }
}
