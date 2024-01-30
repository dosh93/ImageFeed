//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dosh on 18.01.2024.
//

import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeRequest(username: username) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать запрос"])))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                
                self?.avatarURL = userResult.profileImage.small
                print("avatarURL \(self?.avatarURL!)")
                self?.complete(with: .success(userResult.profileImage.small), completion: completion)
            case .failure(let error):
                self?.complete(with: .failure(error), completion: completion)
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(username: String) -> URLRequest? {
        guard let token = OAuth2TokenStorage().token else {
            return nil
        }
        let url = URL(string: "https://api.unsplash.com/users/\(username)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func complete<T>(with result: Result<T, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        completion(result)
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": avatarURL])
        self.task = nil
    }
}
