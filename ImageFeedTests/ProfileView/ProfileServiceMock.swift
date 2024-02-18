//
//  ProfileServiceMock.swift
//  ImageFeedTests
//
//  Created by Dosh on 18.02.2024.
//

import Foundation
import ImageFeed

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile?
    var fetchProfileResult: Result<Profile, Error>?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if let result = fetchProfileResult {
            completion(result)
            if case .success(let profileData) = result {
                self.profile = profileData
            }
        }
    }
}
