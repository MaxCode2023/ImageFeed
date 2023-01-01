//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by macOS on 01.01.2023.
//

import Foundation

fileprivate let tokenKey = "BearerToken"

class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        
        set(newValue) {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
