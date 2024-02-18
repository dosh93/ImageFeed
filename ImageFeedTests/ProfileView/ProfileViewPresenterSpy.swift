//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dosh on 18.02.2024.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var loadProfileDataCalled: Bool = false
    var logoutUserCalled: Bool = false
    var viewController: ProfileViewControllerProtocol?
    
    init(viewController: ProfileViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func loadProfileData() {
        loadProfileDataCalled = true
    }

    func logoutUser() {
        logoutUserCalled = true
    }

    func updateAvatarImage() {
        
    }
}
