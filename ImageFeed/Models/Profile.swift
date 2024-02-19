//
//  Profile.swift
//  ImageFeed
//
//  Created by Dosh on 18.01.2024.
//

import Foundation

public struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}
