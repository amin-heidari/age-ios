//
//  Completion.swift
//  Age
//
//  Created by Amin on 2019-05-29.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

typealias Completion<T> = (_ result: Either<T>) -> Void
