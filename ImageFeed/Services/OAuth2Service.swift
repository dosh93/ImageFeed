//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dosh on 09.01.2024.
//

import Foundation

class OAuth2Service {

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
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

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode,
                      let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }

                do {
                    let dataString = String(data: data, encoding: .utf8)!
                    print("--!__ " + dataString)
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

