//
//  AgeCalculator.swift
//  Age
//
//  Created by Amin on 2019-06-15.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class AgeCalculator {
    
    // MARK: - Constants/Types
    
    class Age {
        let full: Int
        let rational: Double
        var value: Double {
            return Double(full) + rational
        }
        
        fileprivate init(full: Int, rational: Double) {
            self.full = full
            self.rational = rational
        }
    }
    
    // MARK: - Static
    
    // MARK: - API
    
    init(birthDate: BirthDate) {
        self.birthDate = birthDate
    }
    
    var currentAge: Age {
        counter += 1
        
        return Age(full: counter, rational: 0.783652)
    }
    
    // MARK: - Life Cycle
    
    // MARK: - Properties
    
    private var counter = 0
    
    private let birthDate: BirthDate
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
}
