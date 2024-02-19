//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Dosh on 18.02.2024.
//

import Foundation
import ImageFeed
import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var updateNameCalled: Bool = false
    var updateTagCalled: Bool = false
    var updateDescriptionCalled: Bool = false
    var presentCalled: Bool = false
    var presenter: ProfileViewPresenterProtocol?
    
    func updateAvatar(with url: URL) {
    }
    
    func updateName(_ name: String?) {
        updateNameCalled = true
    }
    
    func updateTag(_ tag: String?) {
        updateTagCalled = true
    }
    
    func updateDescription(_ description: String?) {
        updateDescriptionCalled = true
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentCalled = true
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
    }
}
