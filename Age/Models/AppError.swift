//
//  AppError.swift
//  Age
//
//  Created by Amin on 2019-05-31.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

enum AppError: Error {
    case connection
    case certificateExpired
    case authentication
    case parsing
    case unknown
}
