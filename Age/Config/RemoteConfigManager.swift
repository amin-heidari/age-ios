//
//  RemoteConfigManager.swift
//  Age
//
//  Created by Amin on 2019-05-19.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import Foundation

class RemoteConfigManager: NSObject {
    
    // MARK: - Constants/Types
    
    struct CachedRemoteConfig: Codable {
        let remoteConfig: RemoteConfig
        let cachedTime: Date
        
        var isFresh: Bool {
            return cachedTime.compare(Date().addingTimeInterval(-Constants.RemoteConfig.freshCacheTime)) == .orderedDescending
        }
        
        var isExpired: Bool {
            return cachedTime.compare(Date().addingTimeInterval(-Constants.RemoteConfig.expireTime)) == .orderedAscending
        }
    }
    
    // MARK: - Static
    
    // Singleton instance.
    static let shared = RemoteConfigManager()
    
    // MARK: - API
    
    func fetchConfig(completion: @escaping Completion<RemoteConfig>) {
        // Check if there's a fresh copy of the remote config cached.
        if let freshCache = cachedRemoteConfig, freshCache.isFresh {
            completion(.success(freshCache.remoteConfig))
        } else {
            // There either isn't a cache, or if there is one, it's not fresh. So try to make the api call.
            // https://stackoverflow.com/a/30788735
            let dataTaskCompletion: Completion<RemoteConfig> = { [unowned self] (result) in
                switch result {
                case .failure(let error):
                    switch (error) {
                    case AppError.connection:
                        if let cached = self.cachedRemoteConfig, !cached.isExpired {
                            completion(.success(cached.remoteConfig))
                        } else {
                            completion(.failure(error))
                        }
                    default:
                        completion(.failure(error))
                    }
                case .success(let data):
                    self.cachedRemoteConfig = CachedRemoteConfig(remoteConfig: data, cachedTime: Date())
                    completion(.success(data))
                }
            }
            urlSession.dataTask(with: URL(string: Constants.RemoteConfig.url)!, completionHandler: urlSessionCompletion(dataTaskCompletion)).resume()
        }
    }
    
    var remoteConfig: RemoteConfig {
        guard let config = cachedRemoteConfig?.remoteConfig else {
            fatalError("Not supported!")
        }
        return config
    }
    
    // MARK: - Life Cycle
    
    // In order to avoid instances other than `shared` to be created for this type.
    private override init() { }
    
    // MARK: - Properties
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        return URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil
        )
    }()
    
    /// This computed property is the only place in the app wherein `UserDefaultsUtil.cachedRemoteConfig` is used.
    private var cachedRemoteConfig: CachedRemoteConfig? {
        get {
            guard let cachedRemoteConfig = UserDefaultsUtil.cachedRemoteConfig else { return nil }
            if (cachedRemoteConfig.isExpired) {
                UserDefaultsUtil.cachedRemoteConfig = nil
                return nil
            } else {
                return cachedRemoteConfig
            }
        }
        set(newValue){
            UserDefaultsUtil.cachedRemoteConfig = newValue
        }
    }
    
}

// MARK: - URLSessionDelegate
extension RemoteConfigManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Implement certificate pinning.
        // https://medium.com/@dzungnguyen.hcm/ios-ssl-pinning-bffd2ee9efc
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if (errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let remoteCert = NSData(bytes: data, length: size)
                        
                        if remoteCert.isEqual(to: try! NSData(contentsOfFile: Bundle.main.path(forResource: "Config", ofType: "cer")!) as Data) {
                            completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                            return
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
}
