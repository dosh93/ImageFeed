//
//  ProfileViewTest.swift
//  ImageFeedTests
//
//  Created by Dosh on 18.02.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewPresenterCallsLoadProfileData() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy(viewController: viewController)
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.loadProfileDataCalled)
    }
    
    func testViewPresenterCallsLogoutUser() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy(viewController: viewController)
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        viewController.clickLogoutButton(String())
        
        //then
        XCTAssertTrue(presenter.logoutUserCalled)
    }
    
    func testViewControllerCallsPresenter() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let profileServiceMock = ProfileServiceMock()
        let presenter = ProfileViewPresenter(viewController: viewController, authHelper: AuthHelper(), alertHelper: AlertHelper(), profileService: profileServiceMock)
        viewController.configure(presenter)
        let expectation = XCTestExpectation(description: "Ожидание вызова present")

        // When
        presenter.logoutUser()

        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(viewController.presentCalled)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testLoadProfileDataCallsUpdateMethods() {
            // Given
            let viewController = ProfileViewControllerSpy()
            let profileServiceMock = ProfileServiceMock()
            let presenter = ProfileViewPresenter(viewController: viewController, authHelper: AuthHelper(), alertHelper: AlertHelper(), profileService: profileServiceMock)
            
            // Задайте ожидаемый профиль
            let expectedProfile = Profile(username: "user", name: "John Doe", loginName: "@johndoe", bio: "Biography")
            profileServiceMock.profile = expectedProfile

            // When
            presenter.loadProfileData()

            // Then
            XCTAssertTrue(viewController.updateNameCalled)
            XCTAssertTrue(viewController.updateTagCalled)
            XCTAssertTrue(viewController.updateDescriptionCalled)
        }
}
