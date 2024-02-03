//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Dosh on 03.02.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testExample() {
        let service = ImagesListService()
                
                let expectation = self.expectation(description: "Wait for Notification")
                NotificationCenter.default.addObserver(
                    forName: ImagesListService.didChangeNotification,
                    object: nil,
                    queue: .main) { _ in
                        expectation.fulfill()
                    }
                
                service.fetchPhotosNextPage()
                wait(for: [expectation], timeout: 10)
                
                XCTAssertEqual(service.photos.count, 10)
    }
}
