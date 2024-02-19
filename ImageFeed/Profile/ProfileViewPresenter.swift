//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Dosh on 18.02.2024.
//

import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    var viewController: ProfileViewControllerProtocol? { get set }
    func loadProfileData()
    func logoutUser()
    func updateAvatarImage()
}

class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var viewController: ProfileViewControllerProtocol?
    let profileService: ProfileServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    var authHelper: AuthHelperProtocol
    var alertHelper: AlertHelperProtocol

    init(viewController: ProfileViewControllerProtocol, authHelper: AuthHelperProtocol, alertHelper: AlertHelperProtocol, profileService: ProfileServiceProtocol) {
        self.viewController = viewController
        self.authHelper = authHelper
        self.alertHelper = alertHelper
        self.profileService = profileService
        setupProfileImageObserver()
    }

    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setupProfileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateAvatarImage()
        }
    }

    func loadProfileData() {
        guard let profile = profileService.profile else { return }
        viewController?.updateName(profile.name)
        viewController?.updateTag(profile.username)
        viewController?.updateDescription(profile.bio)
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url  = URL(string: profileImageUrl) else { return }
            viewController?.updateAvatar(with: url)
    }

    func logoutUser() {
        let alert = alertHelper.createLogoutAlert {
            self.authHelper.logout {
                guard let window = UIApplication.shared.windows.first else { return }
                window.rootViewController = SplashViewController()
                window.makeKeyAndVisible()
            }
        }

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(alert, animated: true, completion: nil)
        }
    }

    func updateAvatarImage() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url  = URL(string: profileImageUrl)
        else { return }
        viewController?.updateAvatar(with: url)
    }
}

