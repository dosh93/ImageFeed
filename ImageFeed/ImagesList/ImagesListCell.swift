//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dosh on 03.12.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()

        cellImage.kf.cancelDownloadTask()
            
        cellImage.image = nil
        dateLabel.text = nil
        likeButton.setImage(UIImage(named: "like_off"), for: .normal)
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(like: Bool) {
        if (like) { likeButton.setImage(UIImage(named: "like_on"), for: .normal) }
        else { likeButton.setImage(UIImage(named: "like_off"), for: .normal) }
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
