//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by macOS on 22.02.2023.
//

import XCTest
@testable import ImageFeed

final class ImageListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImageListPresenterSpy()
        viewController.configure(presenter)
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testAddPhotos() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImageListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        let imagesListService = presenter.imagesListService
        XCTAssertNotNil(imagesListService.photos)
    }
}

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    var imagesListService: ImageListService = ImageListService()
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        return
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var photosAdded = false
    
    var photos: [Photo] = []
    
    func updateTableViewAnimated(photos: [Photo]) {
        updateTableViewAnimatedCalled = true
    }
}
