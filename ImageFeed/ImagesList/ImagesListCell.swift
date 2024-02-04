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
    
    override func prepareForReuse() {
        super.prepareForReuse()

        cellImage.kf.cancelDownloadTask()
            
        cellImage.image = nil
        dateLabel.text = nil
        likeButton.setImage(UIImage(named: "like_off"), for: .normal)
    }
}
