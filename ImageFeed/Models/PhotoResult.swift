//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Dosh on 03.02.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date
    let width: Int64
    let height: Int64
    let color: String
    let likes: Int
    let likedByUser: Bool
    let description: String
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case likes
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
