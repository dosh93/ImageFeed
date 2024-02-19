//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dosh on 18.01.2024.
//

import Foundation

public protocol ProfileServiceProtocol {
    var profile: Profile? { get set }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeRequest(token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResponse):
                let profile = Profile(username: profileResponse.username, name: "\(profileResponse.firstName) \(profileResponse.lastName)", loginName: "@\(profileResponse.username)", bio: profileResponse.bio)
                self?.profile = profile
                self?.complete(with: .success(profile), completion: completion)
            case .failure(let error):
                self?.complete(with: .failure(error), completion: completion)
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func complete<T>(with result: Result<T, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        completion(result)
        self.task = nil
    }
}
