//
//  AppNavigationController.swift
//  Age
//
//  Created by Amin on 2019-06-01.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
    }
    
}

extension AppNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return (toVC as? UIViewControllerTransitioningDelegate)?.animationController?(forPresented: toVC, presenting: fromVC, source: navigationController)
        case .pop:
            return (fromVC as? UIViewControllerTransitioningDelegate)?.animationController?(forDismissed: fromVC)
        case .none:
            assertionFailure("Not supported")
            return nil
        }
    }
    
}
