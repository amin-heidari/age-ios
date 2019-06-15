//
//  DateUtil.swift
//  Age
//
//  Created by Amin on 2019-06-14.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

extension Date {
    
    var birthDate: BirthDate {
        let calendar = Calendar.current
        return BirthDate(
            year: calendar.component(.year, from: self),
            month: calendar.component(.month, from: self),
            day: calendar.component(.day, from: self)
        )
    }
    
}
