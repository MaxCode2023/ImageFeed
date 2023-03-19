//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by macOS on 22.02.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdates() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let expectation = expectation(description: "Test completed")
        
        ProfileService.shared.fetchProfile { result in
            switch result {
            case .success:
                ProfileImageService.shared.fetchProfileImageURL(username: ProfileService.shared.profile?.username ?? "") { _ in
                    presenter.viewDidLoad()
                    
                    XCTAssertTrue(viewController.updateAvatarCalled)
                    XCTAssertTrue(viewController.updateProfileDetailsCalled)
                    
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
            }
        }

        waitForExpectations(timeout: 10)
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?

    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDetailsCalled = true
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func loadProfileImage() {
        
    }
    
    var profileService: ImageFeed.ProfileService = ImageFeed.ProfileService()
}
