//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dosh on 18.01.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeRequest(token: token)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.complete(with: .failure(error), completion: completion)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                        200...299 ~= httpResponse.statusCode,
                        let data = data else {
                    self.complete(with: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])), completion: completion)
                    return
                }

                do {
                    let profileResponse = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = Profile(username: profileResponse.username, name: "\(profileResponse.firstName) \(profileResponse.lastName)", loginName: "@\(profileResponse.username)", bio: profileResponse.bio)
                    self.profile = profile
                    self.complete(with: .success(profile), completion: completion)
                } catch {
                    self.complete(with: .failure(error), completion: completion)
                }
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
