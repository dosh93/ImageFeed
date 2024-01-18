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
                    let dataString = String(data: data, encoding: .utf8)!
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.complete(with: .success(tokenResponse.accessToken), completion: completion)
                } catch {
                    self.complete(with: .failure(error), completion: completion)
                }
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
            "client_id": accessKey,
            "client_secret": secretKey,
            "redirect_uri": redirectURI,
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

