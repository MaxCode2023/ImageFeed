//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Albert on 03.12.2022.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileDetails(profile: Profile)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    private var image = UIImageView()
    private var labelName = UILabel()
    private var labelNickname = UILabel()
    private var labelStatus = UILabel()
    private let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!, target: ProfileViewController.self, action: nil)

    private let gradientImage = CAGradientLayer()
    private let gradientLabelName = CAGradientLayer()
    private let gradientLabelNickname = CAGradientLayer()
    private let gradientLabelStatus = CAGradientLayer()
    
    var presenter: ProfilePresenterProtocol?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(ProfilePresenter())
        button.addTarget(self, action: #selector(showExitAlert(sender:)), for: .touchUpInside)
        
        setSkeleton()
        addSubviews()
        setViewConfiguration()
        activateConstraints()
        
        presenter?.viewDidLoad()
    }
    
    internal func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        image.kf.setImage(with: url, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    internal func updateProfileDetails(profile: Profile) {
        self.labelName.text = profile.name
        self.labelNickname.text = profile.loginName
        self.labelStatus.text = profile.bio
        endAnimateSkeleton()
    }
    
    private func setSkeleton() {
        image.layer.addSublayer(gradientImage)
        labelName.layer.addSublayer(gradientLabelName)
        labelNickname.layer.addSublayer(gradientLabelNickname)
        labelStatus.layer.addSublayer(gradientLabelStatus)
        
        animateSkeleton(gradientName: gradientImage, size: CGSize(width: 70, height: 70), cornerRadius: 35, keyAnimation: "imageLocationChange")
        animateSkeleton(gradientName: gradientLabelName, size: CGSize(width: 223, height: 18), cornerRadius: 9, keyAnimation: "labelNameLocationChange")
        animateSkeleton(gradientName: gradientLabelNickname, size: CGSize(width: 89, height: 18), cornerRadius: 9, keyAnimation: "labelNicknameLocationChange")
        animateSkeleton(gradientName: gradientLabelStatus, size: CGSize(width: 67, height: 18), cornerRadius: 9, keyAnimation: "labelStatusLocationChange")
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
            labelName.heightAnchor.constraint(equalToConstant: 25),
            labelName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelNickname.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelNickname.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelNickname.heightAnchor.constraint(equalToConstant: 18),
            labelNickname.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            labelStatus.topAnchor.constraint(equalTo: labelNickname.bottomAnchor, constant: 8),
            labelStatus.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelStatus.heightAnchor.constraint(equalToConstant: 18),
            labelStatus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func animateSkeleton(gradientName: CAGradientLayer, size: CGSize, cornerRadius: CGFloat, keyAnimation: String) {
        
        gradientName.frame = CGRect(origin: .zero, size: size)
        gradientName.locations = [0, 0.1, 0.3]
        gradientName.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradientName.startPoint = CGPoint(x: 0, y: 0.5)
        gradientName.endPoint = CGPoint(x: 1, y: 0.5)
        gradientName.cornerRadius = cornerRadius
        gradientName.masksToBounds = true
                
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradientName.add(gradientChangeAnimation, forKey: keyAnimation)
    }
    
    private func endAnimateSkeleton() {
        gradientImage.removeFromSuperlayer()
        gradientLabelStatus.removeFromSuperlayer()
        gradientLabelName.removeFromSuperlayer()
        gradientLabelNickname.removeFromSuperlayer()
    }
    
    @objc func showExitAlert(sender: AnyObject) {
        let alert = UIAlertController(title: "Пока, пока",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да",
                                      style: .default,
                                      handler: { _ in
            OAuth2Service.shared.logout {
                guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
                let splashViewController = SplashViewController()
                window.rootViewController = splashViewController
            }
                                      }))
        alert.addAction(UIAlertAction(title: "Нет",
                                      style: .default,
                                      handler: { _ in
            alert.dismiss(animated: true)
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
}
