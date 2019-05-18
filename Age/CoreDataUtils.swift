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
        guard let birthDate = birth_date, let name = name else { return nil }
        return Birthday(birthDate: birthDate, name: name)
    }
}
