//
//  RemoteConfigManager.swift
//  Age
//
//  Created by Amin on 2019-05-19.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class RemoteConfigManager: NSObject {
    
    static let shared = RemoteConfigManager()
    
    typealias Completion = (_ result: Result) -> Void
    
    enum ConfigError: Error {
        case connection
    }
    
    enum Result {
        case success(_ remoteConfig: RemoteConfig)
        case error(_ error: ConfigError)
    }
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        return URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil
        )
    }()
    
    func fetchConfig(completion: @escaping Completion) {
        urlSession.dataTask(with: URL(string: Constants.RemoteConfig.URL)!) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                completion(.error(.connection))
            }
        }.resume()
    }
    
}

extension RemoteConfigManager: URLSessionDelegate {
    
}
