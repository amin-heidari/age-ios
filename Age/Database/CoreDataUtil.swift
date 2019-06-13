//
//  CoreDataUtils.swift
//  Age
//
//  Created by Amin on 2019-05-17.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

extension BirthdayEntity {
    
    var birthday: Birthday? {
        guard let name = name else { return nil }
        return Birthday(birthDate: BirthDate(year: Int(year), month: Int(month), day: Int(day)), name: name)
    }
    
}
