//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Dosh on 17.12.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var imageURL: URL?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadImage()
    }
    
    func loadImage() {
        if let url = self.imageURL {
            imageView.contentMode = .center
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder_image"),
                options: []) { [weak self] result in
                    UIBlockingProgressHUD.dismiss()
                    guard let self = self else { return }
                    switch result {
                    case .success(let imageResult):
                        imageView.contentMode = .scaleAspectFill
                        self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showErrorAlert()
                    }
                }
        }
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = max(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let imageToShare = imageView.image else { return }

        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)

        present(activityViewController, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить картинку) Попробовать ещё раз?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in self.loadImage() }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
