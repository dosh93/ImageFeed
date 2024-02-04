//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dosh on 03.02.2024.
//

import Foundation

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var taskFetchPhotos: URLSessionTask?
    private var taskLike: URLSessionTask?
    
    func fetchPhotosNextPage() {
        
        if (taskFetchPhotos != nil) { return }
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        guard let request = makeRequest(nextPage: nextPage) else {
            print("Не удалось создать запрос")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { result -> Photo in
                    return Photo(
                        id: result.id,
                        size: CGSize(width: Double(result.width), height: Double(result.height)),
                        createdAt: convertISO8601StringToDate(iso8601String: result.createdAt),
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        isLiked: result.likedByUser
                    )
                }
                DispatchQueue.main.async {
                    self?.photos.append(contentsOf: newPhotos)
                    self?.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["photos": self?.photos])
                    self?.taskFetchPhotos = nil
                }
            case .failure(let error):
                print("Ошибка при загрузке фотографий: \(error)")
                self?.taskFetchPhotos = nil
            }
        }
        self.taskFetchPhotos = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if (taskLike != nil) { return }
        
        guard let request = makeRequest(photoId: photoId, isLike: isLike) else {
            print("Не удалось создать запрос")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode,
                      let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                }
                self.taskLike = nil
                completion(.success(()))
            }
        }
            
        self.taskLike = task
        task.resume()
    }
    
    private func makeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let token = OAuth2TokenStorage().token else {
            return nil
        }
        var components = URLComponents(string: "https://api.unsplash.com/photos/\(photoId)/like")
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if (isLike) { request.httpMethod = "POST" }
        else { request.httpMethod = "DELETE" }
        
        return request
    }
    
    private func makeRequest(nextPage: Int) -> URLRequest? {
        guard let token = OAuth2TokenStorage().token else {
            return nil
        }
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [URLQueryItem(name: "page", value: "\(nextPage)")]
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
}
