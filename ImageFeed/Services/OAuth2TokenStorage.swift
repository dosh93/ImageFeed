//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dosh on 09.01.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "oauth2Token"

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let token = newValue else { return }
            KeychainWrapper.standard.set(token, forKey: tokenKey)
        }
    }
}

