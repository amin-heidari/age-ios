//
//  URLSessionUtil.swift
//  Age
//
//  Created by Amin on 2019-05-31.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

/// This function always invokes the `completion` closure on the main thread.
func urlSessionCompletion<T: Decodable>(_ completion: @escaping Completion<T>) -> ((Data?, URLResponse?, Error?) -> Void) {
    return { (data, urlResponse, error) in
        if let error = error {
            if error.code == NSURLErrorCancelled {
                // Error code being NSURLErrorCancelled doesn't mean certificate pinning has failed,
                // but certificate pinning failure will give NSURLErrorCancelled always.
                // So there may be some false positives here, but that's alright for now.
                DispatchQueue.main.async { completion(.failure(AppError.certificateExpired)) }
            } else if error.code == NSURLErrorNotConnectedToInternet {
                DispatchQueue.main.async { completion(.failure(AppError.connection)) }
            } else {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        } else if let data = data, let parsedData = try? JSONDecoder().decode(T.self, from: data) {
            DispatchQueue.main.async { completion(.success(parsedData)) }
        } else {
            DispatchQueue.main.async { completion(.failure(AppError.parsing)) }
        }
    }
}
