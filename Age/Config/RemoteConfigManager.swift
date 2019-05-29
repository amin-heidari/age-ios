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
    
    private struct CachedRemoteConfig: Codable {
        let remoteConfig: RemoteConfig
        let cachedTime: Date
        
        var isFresh: Bool {
            return cachedTime.compare(Date().addingTimeInterval(-Constants.RemoteConfig.freshCacheTime)) == .orderedDescending
        }
        
        var isExpired: Bool {
            return cachedTime.compare(Date().addingTimeInterval(-Constants.RemoteConfig.expireTime)) == .orderedAscending
        }
    }
    
    enum ConfigError: Error {
        case connection // Failed to connect.
        case certificateExpired // The pinned certificate is expired. An app update should be in the store with the new certificate soon.
        case parsing // Failed to parse remote config response payload.
        case unknown // Other (unknown) errors.
    }
    
    // MARK: - Static
    
    // Singleton instance.
    static let shared = RemoteConfigManager()
    
    // MARK: - API
    
    func fetchConfig(completion: @escaping Completion<RemoteConfig>) {
        // Check if there's a fresh copy of the remote config cached.
        guard let freshCache = cachedRemoteConfig, freshCache.isFresh else {
            // There either isn't a cache, or if there is one, it's not fresh. So try to make the api call.
            urlSession.dataTask(with: URL(string: Constants.RemoteConfig.url)!) { [unowned self] (data, urlResponse, error) in
                if let error = error {
                    if error.code == NSURLErrorCancelled {
                        // Error code being NSURLErrorCancelled doesn't mean certificate pinning has failed,
                        // but certificate pinning failure will give NSURLErrorCancelled always.
                        // So there may be some false positives here, but that's alright for now.
                        DispatchQueue.main.async { completion(.failure(ConfigError.certificateExpired)) }
                    } else if error.code == NSURLErrorNotConnectedToInternet {
                        // There was no internet connection, see if there's a non-expired cached copy to use.
                        // The !cache.isExpired is kinda redundant because the property accessor would have deleted the cache if it was expired.
                        // But that's fine.
                        if let cached = self.cachedRemoteConfig, !cached.isExpired {
                            DispatchQueue.main.async { completion(.success(cached.remoteConfig)) }
                        } else {
                            DispatchQueue.main.async { completion(.failure(ConfigError.connection)) }
                        }
                    } else {
                        DispatchQueue.main.async { completion(.failure(ConfigError.unknown)) }
                    }
                } else {
                    guard let data = data, let remoteConfig = try? JSONDecoder().decode(RemoteConfig.self, from: data) else {
                        DispatchQueue.main.async { completion(.failure(ConfigError.parsing)) }
                        return
                    }
                    self.cachedRemoteConfig = CachedRemoteConfig(remoteConfig: remoteConfig, cachedTime: Date())
                    DispatchQueue.main.async { completion(.success(remoteConfig)) }
                }
                }.resume()
            return
        }
        // A fresh cached copy of the remote config is cached. So we'll use that one and will avoice making a new api call.
        completion(.success(freshCache.remoteConfig))
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
    
    private var cachedRemoteConfig: CachedRemoteConfig? {
        get {
            guard let data = UserDefaults.standard.object(forKey: UserDefaultsUtil.Keys.CachedRemoteConfig.rawValue) as? Data,
                let cachedRemoteConfig = try? PropertyListDecoder().decode(CachedRemoteConfig.self, from: data) else { return nil }
            if (cachedRemoteConfig.isExpired) {
                UserDefaults.standard.set(nil, forKey: UserDefaultsUtil.Keys.CachedRemoteConfig.rawValue)
                return nil
            } else {
                return cachedRemoteConfig
            }
        }
        set(newValue){
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: UserDefaultsUtil.Keys.CachedRemoteConfig.rawValue)
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
