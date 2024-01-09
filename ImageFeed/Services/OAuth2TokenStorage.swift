//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dosh on 09.01.2024.
//

import Foundation

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "oauth2Token"

    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}

