//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Dosh on 18.02.2024.
//

import Foundation
import UIKit

public protocol ImagesListViewPresenterProtocol {
    var viewController: ImagesListViewControllerProtocol? { get set }
    func didTapLikeButton(at index: Int, cell: ImagesListCell)
    func getPhotoCount() -> Int
    func nextPage(at index: Int)
    func getCellHeight(at index: Int, tableWith: CGFloat) -> CGFloat
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func getPhoto(by index: Int) -> Photo
    func viewDidLoad(viewController: ImagesListViewControllerProtocol)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var viewController: ImagesListViewControllerProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService()
    var alertHelper: AlertHelperProtocol = AlertHelper()
    private var imagesListServiceObserver: NSObjectProtocol?
    
    
    func viewDidLoad(viewController: ImagesListViewControllerProtocol) {
        self.viewController = viewController
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        updateTableViewAnimated()
    }
    
    
    func didTapLikeButton(at index: Int, cell: ImagesListCell) {
        let photo = photos[index]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLike: self.photos[index].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = alertHelper.createErrorAlert(message: "Не удалось поставить/снять лайк")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            viewController?.updateTableView(newCount, oldCount)
        }
    }
    
    func getPhotoCount() -> Int {
        photos.count
    }
    
    func nextPage(at index: Int) {
        if (index + 1 == photos.count) {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func getCellHeight(at index: Int, tableWith: CGFloat) -> CGFloat {
        let photo = photos[index]
        let imageSize = photo.size

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableWith - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageSize.width
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let url = URL(string: photos[indexPath.row].thumbImageURL)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.contentMode = .center
        cell.cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder_image"),
            options: []) { result in
                cell.cellImage.contentMode = .scaleAspectFill
                self.viewController?.reloadRows(indexPath: indexPath)
            }
        
        if (photos[indexPath.row].createdAt == nil) {
            cell.dateLabel.text = ""
        } else {
            let currentDate = dateFormatter.string(from: photos[indexPath.row].createdAt!)
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            cell.dateLabel.text = currentDate
        }
        
        let likeImage = photos[indexPath.row].isLiked ? UIImage(named: "like_on") : UIImage(named: "like_off")
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func getPhoto(by index: Int) -> Photo {
        photos[index]
    }
   
}
