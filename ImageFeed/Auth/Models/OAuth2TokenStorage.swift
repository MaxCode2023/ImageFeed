//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by macOS on 01.01.2023.
//

import Foundation
import SwiftKeychainWrapper

fileprivate let tokenKey = "BearerToken"

class OAuth2TokenStorage {
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        
        set(newValue) {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
                
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
