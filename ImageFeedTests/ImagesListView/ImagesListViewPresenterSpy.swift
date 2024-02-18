//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dosh on 18.02.2024.
//

import Foundation
import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var viewController: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func didTapLikeButton(at index: Int, cell: ImagesListCell) {
        
    }
    
    func getPhotoCount() -> Int {
        0
    }
    
    func nextPage(at index: Int) {
        
    }
    
    func getCellHeight(at index: Int, tableWith: CGFloat) -> CGFloat {
        CGFloat()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
    }
    
    func getPhoto(by index: Int) -> Photo {
        Photo(id: "", size: CGSize(), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)
    }
    
    func viewDidLoad(viewController: ImagesListViewControllerProtocol) {
        viewDidLoadCalled = true
    }
}
