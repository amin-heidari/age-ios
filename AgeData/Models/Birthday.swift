//
//  Birthday.swift
//  Age
//
//  Created by Amin on 2019-04-22.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

public class Birthday: Codable {
    public let birthDate: BirthDate
    public let name: String
    
    public init(birthDate: BirthDate, name: String) {
        self.birthDate = birthDate
        self.name = name
    }
    
    private enum CodingKeys: String, CodingKey {
        case birthDate
        case name
    }
}
