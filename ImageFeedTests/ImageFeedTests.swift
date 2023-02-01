//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by macOS on 01.02.2023.
//
@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {
    
    func testFetchPhotos() {
        
        let service = ImageListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
