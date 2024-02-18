//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Dosh on 31.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter(viewController: profileViewController, authHelper: AuthHelper(), alertHelper: AlertHelper(), profileService: ProfileService.shared)
        profileViewController.configure(profileViewPresenter)
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
