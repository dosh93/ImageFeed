//
//  ApiConstants.swift
//  ImageFeed
//
//  Created by Dosh on 19.02.2024.
//

import Foundation

enum ApiConstants {
    static let accessKey = "Q-JApM3NEaDXzNF4EyJxHeeKB8SD6rYIOzy6LcOX85Q"
    static let secretKey = "IuvfrwlSYk9-OpIPhE70dXIUogBlUgZsnl6D8z6_ES8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
