//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by macOS on 21.02.2023.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func loadProfileImage()
    var profileService: ProfileService { get set }
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    var profileService = ProfileService.shared

    func viewDidLoad() {
        
        if let profile = self.profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
        
        loadProfileImage()
    }

    func loadProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar(url: url)
                if let profile = self.profileService.profile {
                    self.view?.updateProfileDetails(profile: profile)
                }
            }
        
        view?.updateAvatar(url: url)
    }
}
