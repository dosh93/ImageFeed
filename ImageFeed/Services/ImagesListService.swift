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
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        
        if (task != nil) { return }
        
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
                    self?.task = nil
                }
            case .failure(let error):
                print("Ошибка при загрузке фотографий: \(error)")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(nextPage: Int) -> URLRequest? {
         let token = OAuth2TokenStorage().token else {
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
