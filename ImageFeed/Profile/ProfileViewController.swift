//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Albert on 03.12.2022.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private var image = UIImageView()
    private var labelName = UILabel()
    private var labelNickname = UILabel()
    private var labelStatus = UILabel()
    private let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: ProfileViewController.self, action: nil)
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?      

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        addSubviews()
        setViewConfiguration()
        activateConstraints()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        image.kf.setImage(with: url, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    private func updateProfileDetails(profile: Profile) {
        self.labelName.text = profile.name
        self.labelNickname.text = profile.loginName
        self.labelStatus.text = profile.bio
    }
    
    private func addSubviews() {
        view.addSubview(image)
        view.addSubview(labelName)
        view.addSubview(labelNickname)
        view.addSubview(labelStatus)
        view.addSubview(button)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelNickname.translatesAutoresizingMaskIntoConstraints = false
        labelStatus.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setViewConfiguration() {
        labelName.textColor = UIColor(named: "YP White")
        labelName.font = labelName.font.withSize(23)
        
        labelNickname.textColor = UIColor(named: "YP Grey")
        labelNickname.font = labelNickname.font.withSize(13)
        
        labelStatus.textColor = UIColor(named: "YP White")
        labelStatus.font = labelStatus.font.withSize(13)
        
        button.tintColor = UIColor(named: "YP Red")
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 70),
            image.widthAnchor.constraint(equalToConstant: 70),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelName.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            labelNickname.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelNickname.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelStatus.topAnchor.constraint(equalTo: labelNickname.bottomAnchor, constant: 8),
            labelStatus.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            button.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
