//
//  URLSessionUtil.swift
//  Age
//
//  Created by Amin on 2019-05-31.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

typealias FullHttpResponse<T> = (data: T, headers: [AnyHashable: Any])

/// This function always invokes the `completion` closure on the main thread.
/// This is a light weight version of `urlSessionFullHttpCompletion` which does not return the headers.
func urlSessionHttpCompletion<T: Decodable>(_ completion: @escaping Completion<T>) -> ((Data?, URLResponse?, Error?) -> Void) {
    let fullCompletion: Completion<FullHttpResponse<T>> = { (fullResult) in
        // No need to spawn main thread here as we're sure this entire block is being executed on the main thread because of the function below.
        switch fullResult {
        case .failure(let error):
            completion(.failure(error))
        case .success(let response):
            completion(.success(response.data))
        }
    }
    
    return urlSessionFullHttpCompletion(fullCompletion)
}

/// This function always invokes the `completion` closure on the main thread.
func urlSessionFullHttpCompletion<T: Decodable>(_ completion: @escaping Completion<FullHttpResponse<T>>) -> ((Data?, URLResponse?, Error?) -> Void) {
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
        } else {
            if let urlResponse = urlResponse as? HTTPURLResponse {
                if ((200..<300).contains(urlResponse.statusCode)) {
                    if let data = data, let parsedData = try? JSONDecoder().decode(T.self, from: data) {
                        DispatchQueue.main.async { completion(.success((parsedData, urlResponse.allHeaderFields))) }
                    } else {
                        DispatchQueue.main.async { completion(.failure(AppError.parsing)) }
                    }
                } else if (urlResponse.statusCode == 403) {
                    DispatchQueue.main.async { completion(.failure(AppError.authentication)) }
                } else {
                    DispatchQueue.main.async { completion(.failure(AppError.unknown)) }
                }
            } else {
                DispatchQueue.main.async { completion(.failure(AppError.unknown)) }
            }
        }
    }
}
