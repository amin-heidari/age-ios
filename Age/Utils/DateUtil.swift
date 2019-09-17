//
//  DateUtil.swift
//  Age
//
//  Created by Amin on 2019-06-14.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation
import AgeData

// https://stackoverflow.com/a/47374042
// all global variables are lazy by default,
// that is why no need (and not allowed) to place keyword "lazy" before the global variable declaration:
// they are already lazy by their nature.
class DateFormatters {
    
    static private(set) var apiGatewayDateHeader: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
    
    static private(set) var birthDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter
    }()
    
}

extension Date {
    
    var birthDate: BirthDate {
        let calendar = Calendar.current
        return BirthDate(
            year: calendar.component(.year, from: self),
            month: calendar.component(.month, from: self),
            day: calendar.component(.day, from: self)
        )
    }
    
    var birthDateFormatted: String {
        return DateFormatters.birthDate.string(from: self)
    }
    
}
