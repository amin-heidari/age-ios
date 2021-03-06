//
//  AgeCalculator.swift
//  Age
//
//  Created by Amin on 2019-07-05.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

public class AgeCalculator {
    
    // MARK: - Constants/Types
    
    public class Age {
        public let full: Int
        public let rational: Double
        public var value: Double {
            return Double(full) + rational
        }
        
        fileprivate init(full: Int, rational: Double) {
            self.full = full
            self.rational = rational
        }
    }
    
    // MARK: - Static
    
    // MARK: - API
    
    public init(birthDate: BirthDate) {
        self.birthDate = birthDate
    }
    
    deinit { }
    
    public var currentAge: Age {
        let now = Date()
        
        var thisYearBirthdayComponents = DateComponents()
        thisYearBirthdayComponents.year = Calendar.current.component(.year, from: now)
        thisYearBirthdayComponents.month = birthDate.month
        thisYearBirthdayComponents.day = birthDate.day
        thisYearBirthdayComponents.minute = 0
        thisYearBirthdayComponents.hour = 0
        thisYearBirthdayComponents.second = 0
        thisYearBirthdayComponents.nanosecond = 0
        
        let thisYearBirthday = Calendar.current.date(from: thisYearBirthdayComponents)!
        
        var lastBirthday: Date
        var nextBirthday: Date
        
        if (now > thisYearBirthday) { // We are past this year's birthday.
            lastBirthday = thisYearBirthday
            nextBirthday = Calendar.current.date(byAdding: .year, value: 1, to: lastBirthday)!
        } else { // The birthday is still ahead of us this year.
            nextBirthday = thisYearBirthday
            lastBirthday = Calendar.current.date(byAdding: .year, value: -1, to: nextBirthday)!
        }
        
        let fullYears = Calendar.current.component(.year, from: lastBirthday) - birthDate.year
        let secondsLastToNextBday = nextBirthday.timeIntervalSince(lastBirthday)
        let secondsLastBdayToNow = now.timeIntervalSince(lastBirthday)
        let yearFraction: Double = Double(secondsLastBdayToNow) / Double(secondsLastToNextBday)
        
        return Age(full: fullYears, rational: yearFraction)
    }
    
    // MARK: - Life Cycle
    
    // MARK: - Properties
    
    private let birthDate: BirthDate
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    // MARK: - Actions
    
}

