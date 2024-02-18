//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dosh on 09.01.2024.
//

import Foundation

final class OAuth2Service {

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = makeRequest(code: code)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let tokenResponse):
                self?.complete(with: .success(tokenResponse.accessToken), completion: completion)
            case .failure(let error):
                self?.complete(with: .failure(error), completion: completion)
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest {
        let url = URL(string: "https://unsplash.com/oauth/token")!
        let parameters = [
            "grant_type": "authorization_code",
            "code": code,
            "client_id": AccessKey,
            "client_secret": SecretKey,
            "redirect_uri": RedirectURI,
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)
        return request
    }
    
    private func complete(with result: Result<String, Error>, completion: @escaping (Result<String, Error>) -> Void) {
        completion(result)
        resetState()
    }
    
    private func resetState() {
        self.lastCode = nil
        self.task = nil
    }
}

