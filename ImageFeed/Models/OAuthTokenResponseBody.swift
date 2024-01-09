//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Dosh on 09.01.2024.
//

struct OAuthTokenResponseBody: Decodable {
    
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: UInt32

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
